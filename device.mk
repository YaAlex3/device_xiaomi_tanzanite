
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Dalvik configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Allow userspace reboots
$(call inherit-product, $(SRC_TARGET_DIR)/product/userspace_reboot.mk)

# Keys
$(call inherit-product-if-exists, vendor/private/keys/keys.mk)

# Bootanimation
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 2400

# Security patch level
VENDOR_SECURITY_PATCH := 2026-05-01
BOOT_SECURITY_PATCH := 2026-05-01

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.boot_security_patch=$(BOOT_SECURITY_PATCH)

# AB OTA Configuration
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    vendor_boot \
    odm_dlkm \
    system \
    system_dlkm \
    system_ext \
    vendor \
    vendor_dlkm \
    product \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    otapreopt_script \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=$(TARGET_RO_FILE_SYSTEM_TYPE) \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=$(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE) \
    POSTINSTALL_OPTIONAL_vendor=true

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Compressed Virtual A/B
#ifneq ($(WITH_GMS),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
TARGET_RO_FILE_SYSTEM_TYPE := ext4
#else
#$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
#PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
#TARGET_RO_FILE_SYSTEM_TYPE := erofs
#PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true
#endif


# Boot control (A/B Updates)
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

# Chipinfo
PRODUCT_PACKAGES += \
    chipinfo

# Audio
TARGET_EXCLUDES_AUDIOFX := true
$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)
$(call soong_config_set,android_hardware_audio,run_64bit,true)
PRODUCT_PACKAGES += \
    audio.usb.default:64 \
    audio.bluetooth.default:64 \
    android.hardware.bluetooth.audio-impl:64 \
    android.hardware.bluetooth-service.mediatek


PRODUCT_PACKAGES += \
    libaudiofoundation.vendor \
    libalsautils \
    libnbaio_mono \
    libtinycompress \
    libdynproc

PRODUCT_PACKAGES += \
    MtkInCallService

# Audio Configuration
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.ranging-service.default \
    android.hardware.bluetooth.finder-service.default

# Display
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.mediatek

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

PRODUCT_PACKAGES += \
    android.hardware.vulkan.compute-0.prebuilt.xml \
    android.hardware.vulkan.level-1.prebuilt.xml \
    android.hardware.vulkan.version-1_3.prebuilt.xml \
    android.software.opengles.deqp.level-2024-03-01.prebuilt.xml \
    android.software.vulkan.deqp.level-2024-03-01.prebuilt.xml

# IR
PRODUCT_PACKAGES += \
    android.hardware.ir-service.example \

PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0

# DRM (Clearkey)
PRODUCT_PACKAGES += \
    com.android.hardware.drm.clearkey

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V4.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# FastbootD
$(call soong_config_set_bool,fastbootd,bypass_lock_state,true)
PRODUCT_PACKAGES += \
    fastbootd

# Fingerprint
$(call soong_config_set,XIAOMI_BIOMETRICS_FINGERPRINT,IMPL_VER,V2)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi \
    libudfpshandler

# Sensors
PRODUCT_PACKAGES += \
    vendor.xiaomi.hardware.fx.tunnel@1.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# IMS
$(call inherit-product, hardware/lineage/compat/frameworks/compat.mk)
$(call inherit-product, hardware/mediatek/frameworks/mediatek-frameworks.mk)
PRODUCT_PACKAGES += \
    xiaomi-telephony-stub

PRODUCT_BOOT_JARS += \
    xiaomi-telephony-stub

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-com.mediatek.ims.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.mediatek.ims.xml \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-com.mediatek.telephony.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.mediatek.telephony.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml

# FM Radio
PRODUCT_PACKAGES += \
    FMRadio

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service \
    android.hardware.health-service.recovery

# Light
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Media
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/media/,$(TARGET_COPY_OUT_VENDOR)/etc)

# MM
PRODUCT_PACKAGES += \
    init.zram.rc \
    fstab.zram

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

$(foreach sku, tanzanite_e_eea tanzanite_n_gl, \
    $(eval PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.nfc.ese.xml \
        frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.nfc.hce.xml \
        frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.nfc.hcef.xml \
        frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.nfc.uicc.xml \
        frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.nfc.xml \
        frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.se.omapi.ese.xml \
        frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/android.hardware.se.omapi.uicc.xml \
        frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/com.android.nfc_extras.xml \
        frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(sku)/com.nxp.mifare.xml))

# Power
$(call soong_config_set,power_libperfmgr,mode_extension_lib, //$(LOCAL_PATH):libperfmgr-ext-xiaomi)
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    libmtkperf_client \
    libmtkperf_client_vendor \
    libpowerhalwrap_vendor \
    vendor.mediatek.hardware.mtkpower-service.stub

$(call soong_config_set_bool,libmtkperf_client,powerhalwrap_aidl,true)

PRODUCT_PACKAGES += \
    PowerOffAlarm

# Power configurations
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Reduce system server verbosity.
PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false

PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal:64 \
    sensors.xiaomi.v2

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soundtrigger
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.3-impl:64

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.mediatek

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/thermal/,$(TARGET_COPY_OUT_VENDOR)/etc)

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.mediatek \
    android.hardware.usb.gadget-service.mediatek \
    init.mt6789.usb.rc

# Enable audio accessory support
$(call soong_config_set_bool,android_hardware_mediatek_usb,audio_accessory_supported,true)

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    wpa_supplicant \
    hostapd \
    libwifi-hal-wrapper:64 \
    wlan_assistant

# Wifi configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/wifi/,$(TARGET_COPY_OUT_VENDOR)/etc/wifi)

# Permissions (features)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.ar.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.ar.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Public Libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Init scripts
PRODUCT_PACKAGES += \
    init.insmod.sh \
    init.insmod.mtk.cfg \
    init.connectivity.rc \
    init_connectivity.rc \
    init.connectivity.common.rc \
    init.fingerprint.rc \
    init.modem.rc \
    init.mt6789.rc \
    init.mt6789.power.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sensor_2_0.rc \
    init.recovery.usb.rc \
    fstab.mt6789 \
    fstab.mt6789.vendor_ramdisk \
    ueventd.mt6789.rc

# GNSS
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

# Overlays
PRODUCT_PACKAGES += \
    ApertureOverlayTanzanite \
    FrameworksResOverlayTanzanite \
    TetheringResOverlayTanzanite \
    WifiResOverlayTanzanite \
    SettingsResOverlayTanzanite \
    SettingsProviderResOverlayTanzanite \
    SystemUIOverlayTanzanite \
    TelephonyOverlayTanzanite \

# Properties
include $(LOCAL_PATH)/vendor_logtag.mk

# Sku properties
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/sku/,$(TARGET_COPY_OUT_VNDOR)/)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/mediatek \
    hardware/mediatek/libmtkperf_client \
    hardware/mediatek/libion_mtk \
    hardware/xiaomi \
    hardware/google/interfaces \
    hardware/google/pixel/pixelstats \
    hardware/google/pixel/power-libperfmgr

# Shipping API Level
PRODUCT_SHIPPING_API_LEVEL := 34

# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.mediatek

TARGET_USES_VULKAN := true

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/tanzanite/tanzanite-vendor.mk)
