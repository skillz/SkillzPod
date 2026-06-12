/usr/bin/perl -x "$0"
exit

#!perl start here
use strict;

$ENV{PATH} = $ENV{PATH} . ':/usr/libexec';

my $BUILT_PRODUCTS_DIR = $ENV{'BUILT_PRODUCTS_DIR'};
my $INFOPLIST_PATH = $ENV{'INFOPLIST_PATH'};
my $CODE_SIGN_ENTITLEMENTS = $ENV{'CODE_SIGN_ENTITLEMENTS'};
my $PRODUCT_BUNDLE_IDENTIFIER = $ENV{'PRODUCT_BUNDLE_IDENTIFIER'};
my $TEAM_IDENTIFIER_PREFIX = $ENV{'TeamIdentifierPrefix'};
# escape some troublesome path characters
$BUILT_PRODUCTS_DIR =~ s!'!\'!g;
$BUILT_PRODUCTS_DIR =~ s!"!\"!g;
$BUILT_PRODUCTS_DIR =~ s! !\ !g;

$INFOPLIST_PATH =~ s!'!\'!g;
$INFOPLIST_PATH =~ s!"!\"!g;
$INFOPLIST_PATH =~ s! !\ !g;

print "Running Skillz SDK post processing script" . "\n";

print "Built Products Path: " . $BUILT_PRODUCTS_DIR . "\n";
print "Info.plist Path: " . $INFOPLIST_PATH . "\n";

# Get platform version, warn the developer if it is below the suggested Platform Version

my $dtPlatformVersion = `PlistBuddy -c \'Print DTPlatformVersion\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
if( $dtPlatformVersion < 12 ) {
   print "warning: Skillz suggests Platform Version 12.0 or above. Your Platform Version is: " . $dtPlatformVersion ;
}

# add AppID (teamIdentifier.ProductBundleID)
`PlistBuddy -c \'Add :AppID string \"${TEAM_IDENTIFIER_PREFIX}${PRODUCT_BUNDLE_IDENTIFIER}\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add Plist value to properly inform user of Location Request for iOS 8

my $locationAlwaysAndWhenInUse  = `PlistBuddy -c \'Print NSLocationAlwaysAndWhenInUseUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
if (!length($locationAlwaysAndWhenInUse)) {
   `PlistBuddy -c \'Add :NSLocationAlwaysAndWhenInUseUsageDescription string \"To keep our community safe, your location is required in order to play for real-world prizes\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $locationInUse = `PlistBuddy -c \'Print NSLocationWhenInUseUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($locationInUse)) {
   `PlistBuddy -c \'Add :NSLocationWhenInUseUsageDescription string \"Due to legal requirements we require your location in games that can be played for cash.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $locationAlways = `PlistBuddy -c \'Print NSLocationAlwaysUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($locationAlways)) {
`PlistBuddy -c \'Add :NSLocationAlwaysUsageDescription string \"Due to legal requirements we require your location in games that can be played for cash.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

# Add Plist value to properly inform user of Bluetooth and Motion Usage Request
my $bluetoothAlways  = `PlistBuddy -c \'Print NSBluetoothAlwaysUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
if (!length($bluetoothAlways)) {
   `PlistBuddy -c \'Add :NSBluetoothAlwaysUsageDescription string \"Bluetooth access ensures that cheaters cannot use external devices to defraud you and other users.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $bluetoothPeripheral = `PlistBuddy -c \'Print NSBluetoothPeripheralUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($bluetoothPeripheral)) {
   `PlistBuddy -c \'Add :NSBluetoothPeripheralUsageDescription string \"Bluetooth access ensures that cheaters cannot use external devices to defraud you and other users.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $motionUsage = `PlistBuddy -c \'Print NSMotionUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($motionUsage)) {
`PlistBuddy -c \'Add :NSMotionUsageDescription string \"Motion-data helps detect suspicious behavior associated with cheating.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

# Add Plist value to properly inform user of camera roll usage for iOS 11

my $photoLibraryUsage = `PlistBuddy -c \'Print NSPhotoLibraryAddUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($photoLibraryUsage)) {
   `PlistBuddy -c \'Add :NSPhotoLibraryAddUsageDescription string \"This allows you to save photos to your camera roll.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $contactsInUse = `PlistBuddy -c \'Print NSContactsUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($contactsInUse)) {
    `PlistBuddy -c \'Add :NSContactsUsageDescription string \"Your contacts will be uploaded to the Skillz servers so you can easily find friends to chat and play.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $photosInUse = `PlistBuddy -c \'Print NSPhotoLibraryUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($photosInUse)) {
`PlistBuddy -c \'Add :NSPhotoLibraryUsageDescription string \"Skillz uses access to your photo album to customize your profile picture.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $cameraInInUse = `PlistBuddy -c \'Print NSCameraUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($cameraInInUse)) {
`PlistBuddy -c \'Add :NSCameraUsageDescription string \"Skillz can access your camera to customize your profile picture.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $calendarInInUse = `PlistBuddy -c \'Print NSCalendarsUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($calendarInInUse)) {
`PlistBuddy -c \'Add :NSCalendarsUsageDescription string \"Skillz requires access to the calendar to store events invite.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}


my $idfaInUse = `PlistBuddy -c \'Print NSUserTrackingUsageDescription\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($idfaInUse)) {
`PlistBuddy -c \'Add :NSUserTrackingUsageDescription string \"Your data allows for the optimization of the in-app ad experience for you.\"\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

# Add Plist value to respect view controller status bar appearance
`PlistBuddy -c \'Delete :UIViewControllerBasedStatusBarAppearance\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
`PlistBuddy -c \'Add :UIViewControllerBasedStatusBarAppearance bool YES\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add Plist value to require full screen
`PlistBuddy -c \'Delete :UIRequiresFullScreen\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
`PlistBuddy -c \'Add :UIRequiresFullScreen bool YES\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add Plist value to prevent limited photo permission prompt
`PlistBuddy -c \'Delete :PHPhotoLibraryPreventAutomaticLimitedAccessAlert\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
`PlistBuddy -c \'Add :PHPhotoLibraryPreventAutomaticLimitedAccessAlert bool YES\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add AdNetworks for SKAdNetwork support

my $adNetworkIds = `PlistBuddy -c \'Print SKAdNetworkItems\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
my $dylib = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/Skillz.framework/";

if (!length($adNetworkIds)) {
    `PlistBuddy -c \'Add :SKAdNetworkItems array\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Merge "$dylib/AdNetworks.plist" :SKAdNetworkItems:\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
} else {
    `PlistBuddy -c \'Merge "$dylib/AdNetworks.plist" :SKAdNetworkItems:\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

# Add SKAdNetwork attribution report endpoint for Appsflyer
`PlistBuddy -c \'Delete :NSAdvertisingAttributionReportEndpoint\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
`PlistBuddy -c \'Add :NSAdvertisingAttributionReportEndpoint string https://appsflyer-skadnetwork.com/\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add Plist value to use Light theme
my $UIUserInterfaceStyleExists = `PlistBuddy -c \'Print UIUserInterfaceStyle\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
if (length($UIUserInterfaceStyleExists)) {
    print "Note: Due to the Skillz theming engine, we currently do not support the automatic Dark Mode UI adjustments made by iOS, and are updating your Info.plist to reflect this.\n";
    `PlistBuddy -c \'Delete :UIUserInterfaceStyle\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}
`PlistBuddy -c \'Add :UIUserInterfaceStyle string Light\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

# Add Custom URL Scheme unique to your game.
my $bundleId = `PlistBuddy -c \"Print CFBundleIdentifier\" "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
$bundleId =~ s/\R//g;
my $customURLScheme = "skillz.gamelinks." . $bundleId;
print "Custom url scheme: $customURLScheme \n";

my $customPaymentsURLScheme = $bundleId . ".skillz.gamelinks.payments";
print "Custom payments url scheme: $customPaymentsURLScheme \n";

my $customVenmoUrlScheme = "com.venmo.touch.v2";
print "Custom venmo url scheme: $customVenmoUrlScheme \n";


my $bundleTypes = `PlistBuddy -c \'Print CFBundleURLTypes\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($bundleTypes)) {
    print "CFBundleURLTypes does not yet exist, create it.\n";
    `PlistBuddy -c \'Add :CFBundleURLTypes array\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleURLTypes: dict\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \"Add :CFBundleURLTypes:0:CFBundleURLName string ${customURLScheme}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :CFBundleURLTypes:0:CFBundleURLName string ${customPaymentsURLScheme}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \'Add :CFBundleURLTypes:0:CFBundleURLSchemes array\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \"Add :CFBundleURLTypes:0:CFBundleURLSchemes: string "${customURLScheme}"\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
     `PlistBuddy -c \"Add :CFBundleURLTypes:0:CFBundleURLSchemes: string "${customPaymentsURLScheme}"\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
} else {
    sub add_scheme_if_needed
    {
        my $scheme = $_[0];
        my $schemeTwo = $_[1];

        print "CFBundleURLTypes exists, check if we should add Skillz scheme: $scheme. \n";
        # Only add our custom scheme if it does not yet exist
        my $customScheme = `grep "$scheme" "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

        if (!length($customScheme)) {
            print "Skillz URL scheme $scheme not yet set \n";
            my $temporaryPlistDirectory = `dirname "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
            $temporaryPlistDirectory =~ s/\R//g;
            my $tempPlistName = "/urlScheme.plist";
            my $temporaryPlistPath = $temporaryPlistDirectory . $tempPlistName;

            unlink "$temporaryPlistPath";


            my $fileContents = "
                        <array>
                            <dict>
                                <key>CFBundleURLName</key>
                                    <string>${scheme}</string>
                                <key>CFBundleURLSchemes</key>
                                <array>
                                    <string>${scheme}</string>
                                    <string>${schemeTwo}</string>
                                </array>
                            </dict>
                        </array>";

            open(my $fh, '>', "$temporaryPlistPath");
            print "$fh" . "$fileContents" . "\n";
            print $fh $fileContents;
            close $fh;

            `PlistBuddy -c \'Merge "$temporaryPlistPath" :CFBundleURLTypes:\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

            unlink "$temporaryPlistPath";

        } else {
            print "Skillz URL scheme $scheme already set \n";
        }
    }
    add_scheme_if_needed($customURLScheme, $customPaymentsURLScheme);
}

# Add Application Queries Schemes
my $customQueryScheme = "com.venmo.touch.v2";

my $cydia = "cydia";
my $undecimus = "undecimus";
my $sileo = "sileo";
my $zbra = "zbra";
my $filza = "filza";
my $activator = "activator";
my $appStore = "itms-apps";


my $queriesScheme = `PlistBuddy -c \'Print LSApplicationQueriesSchemes\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($queriesScheme)) {
    print "LSApplicationQueriesSchemes does not yet exist, create it.\n";
    `PlistBuddy -c \'Add :LSApplicationQueriesSchemes array\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:0 string ${customQueryScheme}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:1 string ${cydia}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:2 string ${undecimus}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:3 string ${sileo}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:4 string ${zbra}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:5 string ${filza}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:6 string ${activator}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
    `PlistBuddy -c \"Add :LSApplicationQueriesSchemes:7 string ${appStore}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;


} else {
    sub add_application_scheme_if_needed
    {
        my $scheme = $_[0];
        my $schemeTwo = $_[1];

        print "CFBundleURLTypes exists, check if we should add  scheme: $scheme. \n";
        my $customScheme = `grep "$scheme" "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
        my $customTwoScheme = `grep "$schemeTwo" "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

        if (!length($customScheme) || !length($customTwoScheme)) {
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${customQueryScheme}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${cydia}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${undecimus}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${sileo}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${zbra}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${filza}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${activator}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            `PlistBuddy -c \"Add :LSApplicationQueriesSchemes: string ${appStore}\" \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}\"`;
            
        }
    }
    add_application_scheme_if_needed($customQueryScheme, $cydia);
}

# Add fetch background mode
if (system("PlistBuddy -c \'Print :UIBackgroundModes\' " . "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH")) {
    print "Adding background modes";

    `PlistBuddy -c \'Add :UIBackgroundModes array\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

if (`PlistBuddy -c \'Print :UIBackgroundModes\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"` !~ /fetch/) {
    print "Adding fetch background mode";
    `PlistBuddy -c \'Add :UIBackgroundModes: string fetch\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

# Set up localization.
my $localizations = `PlistBuddy -c \'Print CFBundleLocalizations:\' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;

if (!length($localizations)) {

    `PlistBuddy -c \'Add :CFBundleLocalizations array\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:0 string en\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:1 string de\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:2 string es\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:3 string fr\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:4 string it\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:5 string ja\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:6 string pt\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:7 string ru\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
    `PlistBuddy -c \'Add :CFBundleLocalizations:8 string zh-Hans\' "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;
}

my $skillzDict =  `PlistBuddy -c \'Print :skillzSDK:environment\'  "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"`;

if ($skillzDict =~ /Production/i && $ENV{'CONFIGURATION'} =~ /Debug/i) {
  print "Debug Configuration is used for  Production build";
  exit 1;
}

my $entitlements = `PlistBuddy -c \'Print :com.apple.developer.associated-domains\' "${CODE_SIGN_ENTITLEMENTS}"`;

if (!length($entitlements)) {
    `PlistBuddy -c \"Add :com.apple.developer.associated-domains array\" $CODE_SIGN_ENTITLEMENTS`;

    `PlistBuddy -c \"Add :com.apple.developer.associated-domains:0 string \'applinks:dl.skillz.com\'\" "${CODE_SIGN_ENTITLEMENTS}"`;
 
    `PlistBuddy -c \"Add :com.apple.developer.associated-domains:0 string \'webcredentials:skillz.com\'\" "${CODE_SIGN_ENTITLEMENTS}"`;
}

my $wifiInfoEntitlements = `PlistBuddy -c \'Print :com.apple.developer.networking.wifi-info\' "${CODE_SIGN_ENTITLEMENTS}"`;

if (!length($wifiInfoEntitlements)) {
    `PlistBuddy -c \"Add :com.apple.developer.networking.wifi-info bool YES\" $CODE_SIGN_ENTITLEMENTS`;
}

# Add NSSupportsLiveActivities to Info.plist if it doesn't exist
my $supportsLiveActivities = `PlistBuddy -c 'Print NSSupportsLiveActivities' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
if (!length($supportsLiveActivities)) {
    `PlistBuddy -c 'Add :NSSupportsLiveActivities bool YES' "$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"`;
}

my $appGroupsEntitlements = `PlistBuddy -c \'Print :com.apple.security.application-groups\' "${CODE_SIGN_ENTITLEMENTS}"`;
my $appGroupIdentifier = "group.$PRODUCT_BUNDLE_IDENTIFIER";
if (!length($appGroupsEntitlements)) {
    # No array exists, create and add
    `PlistBuddy -c "Add :com.apple.security.application-groups array" $CODE_SIGN_ENTITLEMENTS`;
    `PlistBuddy -c "Add :com.apple.security.application-groups:0 string $appGroupIdentifier" $CODE_SIGN_ENTITLEMENTS`;
} else {
    # Check if the group already exists
    if ($appGroupsEntitlements !~ /\Q$appGroupIdentifier\E/) {
        # Find the current count of items in the array
        my @lines = split /\n/, $appGroupsEntitlements;
        my $count = 0;
        foreach my $line (@lines) {
            $count++ if $line =~ /^\s*\d+\s*:/;
        }
        # Add the new group at the next index
        `PlistBuddy -c "Add :com.apple.security.application-groups:$count string $appGroupIdentifier" $CODE_SIGN_ENTITLEMENTS`;
    }
}

# ==== strip bitcode from KochavaCore & KochavaTracker ====
for my $fw (qw(KochavaCore KochavaTracker)) {
    my $fwDir    = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/$fw.framework";
    my $binary   = "$fwDir/$fw";
    if (-e $binary) {
        print "Stripping bitcode from $fw: $binary\n";
        system("xcrun bitcode_strip -r \"$binary\" -o \"$binary\"")
          and die "ERROR: bitcode_strip failed on $fw\n";
    } else {
        print "Warning: $fw binary not found at $binary\n";
    }
}
# ==== end strip bitcode ====

my $codeSignIdentity =  $ENV{'EXPANDED_CODE_SIGN_IDENTITY'};
my $dylib = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/Skillz.framework/Skillz";
my $signingPathSkillz = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/Skillz.framework";
my $signingPathKochavaCore = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/KochavaCore.framework";
my $signingPathKochavaTracker = "$BUILT_PRODUCTS_DIR/" . $ENV{'FRAMEWORKS_FOLDER_PATH'} . "/KochavaTracker.framework";
my $shouldSign = ($codeSignIdentity ne "") && (defined $codeSignIdentity) && -e "$signingPathSkillz";

print "Code sign identity: $codeSignIdentity \n";
print "Signing Path: $signingPathSkillz \n";

if ( $ENV{'DEPLOYMENT_LOCATION'} eq "YES") {
    my $fileResult = `file "$dylib" `;
    print `/usr/bin/lipo "$dylib" -info`;
    if (index($fileResult, "x86_64") != -1) {
        print "Exporting for release, remove unused arch x86_64. \n";
        my $tempfile = `mktemp -t skillz`;
        `/usr/bin/lipo -output "$tempfile" -remove x86_64 "$dylib"`;
        `unlink "$dylib"`;
        `mv "$tempfile" "$dylib"`;
        print "Arch x86_64 found, removed \n";
        
    }
    if (index($fileResult, "i386") != -1)  {
        print "Exporting for release, remove unused arch i386. \n";
        my $tempfile = `mktemp -t skillz`;
        `/usr/bin/lipo -output "$tempfile" -remove i386 "$dylib"`;
        `unlink "$dylib"`;
        `mv "$tempfile" "$dylib"`;
        print "Arch i386 found, removed \n";
    }
    
    print `/usr/bin/lipo "$dylib" -info`;
    
    print "Archiving or building for release, remove self \n";
    `rm "$0"`;

    if ($shouldSign) {
        print "Signing Skillz \n";
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathSkillz"`;
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathKochavaTracker"`;
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathKochavaCore"`;
    } else {
        print "No identity or no framework, not signing \n";
    }
} else {
    if ($shouldSign) {
        print "Signing Skillz \n";
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathSkillz"`;
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathKochavaTracker"`;
        `/usr/bin/codesign --force --verbose --sign "$codeSignIdentity" --preserve-metadata=identifier,entitlements,resource-rules "$signingPathKochavaCore"`;
    } else {
        print "No identity or no framework, not signing \n";
    }
}
