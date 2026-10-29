#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/onyx/noteair/device.mk)

PRODUCT_DEVICE := noteair
PRODUCT_NAME := twrp_noteair
PRODUCT_BRAND := GlassineOS
PRODUCT_MODEL := Onyx Boox Note Air
PRODUCT_MANUFACTURER := onyx
