#!/bin/sh -x
PATH=/usr/libexec:$PATH

echo "Running Skillz SDK post processing script"

#Add Plist value to properly inform user of Location Request for iOS 8
if ! PlistBuddy -c 'Print NSLocationWhenInUseUsageDescription' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}";
then
   PlistBuddy -c 'Add :NSLocationWhenInUseUsageDescription string "Due to legal requirements we require your location in games that can be played for cash."' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi

#Add Plist value to respect view controller status bar appearance
if ! PlistBuddy -c 'Print UIViewControllerBasedStatusBarAppearance' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}";
then
    PlistBuddy -c 'Delete :UIViewControllerBasedStatusBarAppearance' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :UIViewControllerBasedStatusBarAppearance bool YES' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi

#Add Custom URL Scheme unique to your game.
bundleId=$(PlistBuddy -c "Print CFBundleIdentifier" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" )
customURLScheme="skillz.gamelinks.$bundleId"

if ! PlistBuddy -c 'Print CFBundleURLTypes' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}";
then
    PlistBuddy -c 'Add :CFBundleURLTypes array' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleURLTypes: dict' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLName string $customURLScheme" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleURLTypes:0:CFBundleURLSchemes array' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes: string $customURLScheme" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
else
#Only add our custom scheme if it does not yet exist
if ! grep --quiet $customURLScheme "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}";
then
temporaryPlistPath=$(dirname "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}")/urlScheme.plist
rm -f "$temporaryPlistPath"

    cat > $temporaryPlistPath <<- EOM
        <array>
            <dict>
                <key>CFBundleURLName</key>
                <string>$customURLScheme</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>$customURLScheme</string>
                </array>
            </dict>
        </array>
EOM

merge_cmd=`printf "PlistBuddy -c \"Merge %q :CFBundleURLTypes:\" %q/%q" "$temporaryPlistPath" "${BUILT_PRODUCTS_DIR}" "${INFOPLIST_PATH}"`

$merge_cmd
rm "$temporaryPlistPath"
fi
fi

# Set up localization.
if ! PlistBuddy -c 'Print CFBundleLocalizations:' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
then
    PlistBuddy -c 'Add :CFBundleLocalizations array' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:0 string en' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:1 string de' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:2 string es' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:3 string fr' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:4 string it' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:5 string ja' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:6 string pt' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:7 string ru' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
    PlistBuddy -c 'Add :CFBundleLocalizations:8 string zh-Hans' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi

# Delete Retina HD images from plist to avoid issues with the Skillz SDK
if PlistBuddy -c 'Print UILaunchImages:' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
then
    IMAGE_LEN="$(PlistBuddy -c 'Print UILaunchImages:' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" | grep 'Dict' | wc -l)"
    IDX=0
    while [ "$IDX" -lt "$IMAGE_LEN" ]; do
        if PlistBuddy -c "Print UILaunchImages:${IDX}:UILaunchImageSize" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" | grep '\(, 667\|, 736\)'
        then
            PlistBuddy -c "Delete UILaunchImages:${IDX}" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
            IMAGE_LEN=$(($IMAGE_LEN - 1))
        else
            IDX=$(($IDX + 1))
        fi
    done
fi

# Delete Launch Storyboard because it forces native resolution
if PlistBuddy -c 'Print :UILaunchStoryboardName' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
then
    PlistBuddy -c 'Delete :UILaunchStoryboardName' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi
if PlistBuddy -c 'Print :UILaunchStoryboardName~iphone' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
then
    PlistBuddy -c 'Delete :UILaunchStoryboardName~iphone' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi
if PlistBuddy -c 'Print :UILaunchStoryboardName~ipad' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
then
    PlistBuddy -c 'Delete :UILaunchStoryboardName~ipad' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
fi

if [ ${DEPLOYMENT_LOCATION} = "YES" ]
then
rm -- "$0"
fi

