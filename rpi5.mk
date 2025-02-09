#
# Copyright 2020 Android-RPi Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
USE_OEM_TV_APP := true
$(call inherit-product, device/google/atv/products/atv_base.mk)

PRODUCT_NAME := rpi5
PRODUCT_DEVICE := rpi5
PRODUCT_BRAND := arpi
PRODUCT_MANUFACTURER := ARPi
PRODUCT_MODEL := Raspberry Pi 5

include frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk

PRODUCT_PROPERTY_OVERRIDES += \
    debug.drm.mode.force=1024x600 \
    ro.sf.lcd_density=160  # Set mdpi density for this resolution
    gralloc.drm.kms=/dev/dri/card1 \
    ro.opengles.version=196609 \
    ro.hardware.vulkan=broadcom \
    ro.hardware.egl=mesa \
    ro.hdmi.device_type=4 \
    wifi.interface=wlan0 \
    ro.rfkilldisabled=1 \
    keyguard.no_require_sim=true \
    ro.config.ringtone=Girtab.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Oxygen.ogg
# Common Automotive Packages
PRODUCT_PACKAGES += \
    Bluetooth \
    CarFrameworkServices \
    CarActivityResolver \
    CarDeveloperOptions \
    CarSettingsIntelligence \
    CarManagedProvisioning \
    CarProvision \
    StatementService \
    SystemUpdater \
    CarLauncher \
    CarSystemUI \
    OverviewApp \
    CarMediaApp \
    LocalMediaPlayer \
    CarRadioApp \
    CarMessengerApp \
    CarDialerApp \
    CarMapsPlaceholder \
    CarFramework

# overlay packages
PRODUCT_PACKAGES += \
    RpFrameworkOverlay

# system packages
PRODUCT_PACKAGES += \
    gralloc.rpi5 \
    vulkan.broadcom \
    memtrack.rpi5 \
    audio.primary.rpi5 \
    audio.usb.default \
    audio.r_submix.default \
    wificond \
    wifilogd \
    wpa_supplicant \
    wpa_supplicant.conf \
    hostapd \
    libbt-vendor

# graphics hal
PRODUCT_PACKAGES += \
    libEGL_mesa \
    libGLESv1_CM_mesa \
    libGLESv2_mesa \
    libgallium_dri \
    libglapi

# hardware/interfaces
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-service.arpi \
    android.hardware.graphics.mapper@4.0-impl.arpi \
    android.hardware.graphics.composer-service.arpi \
    android.hardware.camera.provider@2.5-external-service \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.audio.service \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl \
    android.hardware.health.storage@1.0-service \
    android.hardware.wifi@1.0-service \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.configstore@1.1-service \
    android.hardware.tv.hdmi.connection-service \
    android.hardware.tv.hdmi.cec-service \
    android.hardware.tv.hdmi.earc-service \
    hwservicemanager \
    vndservicemanager
# Enable multi-user and headless system user mode
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.fw.mu.headless_system_user?=true \
    android.car.user_hal_enabled?=true
# SEPolicy for test apps/services in development builds
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += \
    GarageModeTestApp \
    ExperimentalCarService \
    SampleCustomInputService \
    RailwayReferenceApp
PRODUCT_PRIVATE_SEPOLICY_DIRS += packages/services/Car/car_product/sepolicy/test
endif

# Disable SurfaceFlinger shader cache for faster boot times
PRODUCT_PROPERTY_OVERRIDES += service.sf.prime_shader_cache=0
# SEPolicy and overlays
$(call inherit-product, device/sample/products/location_overlay.mk)
$(call inherit-product, packages/services/Car/car_product/build/car_base.mk)

# Locale: English (US) only
PRODUCT_LOCALES := en_US
# System server and boot JARs
PRODUCT_BOOT_JARS += android.car
PRODUCT_SYSTEM_SERVER_JARS += car-frameworks-service
# system configurations
PRODUCT_COPY_FILES := \
    hardware/broadcom/wlan/bcmdhd/config/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml \
    $(LOCAL_PATH)/etc/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml \
    $(LOCAL_PATH)/init.usb.rc:root/init.usb.rc \
    $(LOCAL_PATH)/init.rpi5.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rpi5.rc \
    $(LOCAL_PATH)/init.rpi5.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rpi5.usb.rc \
    $(LOCAL_PATH)/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/fstab.rpi5:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rpi5 \
    $(LOCAL_PATH)/fstab.rpi5:$(TARGET_COPY_OUT_RAMDISK)/fstab.rpi5 \
    $(LOCAL_PATH)/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.bin:root/lib/firmware/brcm/brcmfmac43455-sdio.bin \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.bin:$(TARGET_COPY_OUT_RAMDISK)/lib/firmware/brcm/brcmfmac43455-sdio.bin \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.clm_blob:root/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.clm_blob:$(TARGET_COPY_OUT_RAMDISK)/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.txt:root/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt \
    $(LOCAL_PATH)/firmware/brcm/brcmfmac43455-sdio.txt:$(TARGET_COPY_OUT_RAMDISK)/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt \
    $(LOCAL_PATH)/firmware/brcm/BCM4345C0.hcd:root/lib/firmware/brcm/BCM4345C0.hcd \
    $(LOCAL_PATH)/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
    $(PRODUCT_COPY_FILES)

# media configurations
PRODUCT_COPY_FILES := \
    device/generic/goldfish/camera/media/profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/generic/goldfish/camera/media/codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/etc/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/base/data/sounds/effects/ogg/Effect_Tick_48k.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ui/Effect_Tick.ogg \
    frameworks/base/data/sounds/effects/ogg/camera_click_48k.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ui/camera_click.ogg \
    $(PRODUCT_COPY_FILES)

PRODUCT_AAPT_PREF_CONFIG := mdpi
PRODUCT_CHARACTERISTICS := 

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
# Boot animation
PRODUCT_COPY_FILES += \
    packages/services/Car/car_product/bootanimations/bootanimation-832.zip:system/media/bootanimation.zip