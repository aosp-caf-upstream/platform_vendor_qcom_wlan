WLAN_CHIPSET := qca_cld3

PRODUCT_PACKAGES += \
	wpa_supplicant_overlay.conf \
	p2p_supplicant_overlay.conf \
	wificond \
	wifilogd

#PRODUCT_COPY_FILES += \
#	device/qcom/wlan/sm6150_au/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
#	device/qcom/wlan/sm6150_au/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \

# Enable STA+SAP+P2P
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
QC_WIFI_HIDL_FEATURE_STA_SAP_P2P := true

######## For multiple ko support ########

# whether to load/unload wlan driver dynamically
PRODUCT_WLAN_DRIVER_ALWAYS_LOADED := true

# WLAN driver configuration file
ifeq ($(strip $(shell expr $(words $(strip $(TARGET_WLAN_CHIP))) \>= 2)), 1)
PRODUCT_COPY_FILES += \
$(foreach chip, $(TARGET_WLAN_CHIP), \
    device/qcom/wlan/sm6150_au/WCNSS_qcom_cfg_$(chip).ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/$(chip)/WCNSS_qcom_cfg.ini)
else
TARGET_WLAN_CHIP := wlan
PRODUCT_COPY_FILES += \
    device/qcom/wlan/sm6150_au/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini
endif

PRODUCT_PACKAGES += $(foreach chip, $(TARGET_WLAN_CHIP), $(WLAN_CHIPSET)_$(chip).ko)

ifeq ($(PRODUCT_WLAN_DRIVER_ALWAYS_LOADED), true)
# this script will set the property 'ro.vendor.wlan.chip' when boot completed,
# which will trigger wlan driver loading.
PRODUCT_PACKAGES += init.qcom.wlan.sh
PRODUCT_COPY_FILES += \
    device/qcom/wlan/sm6150_au/init.qcom.wlan.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.wlan.sh
endif
