{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  pkgs,
}:

let
  # This attrset can in theory be computed automatically, but for that to work nicely we need
  # import-from-derivation to work properly. Currently it's rather ugly when we try to bootstrap
  # a stdenv out of something like this. With some care we can probably get rid of this, but for
  # now it's staying here.
  versions = {
    "macos-14.3" = {
      system_cmds = "970.0.4";
    };
    "osx-10.12.6" = {
      xnu = "3789.70.16";
      Libnotify = "165.20.1";
      objc4 = "709.1";
      dyld = "433.5";
      CommonCrypto = "60092.50.5";
      copyfile = "138";
      ppp = "838.50.1";
      libclosure = "67";
      Libinfo = "503.50.4";
      Libsystem = "1238.60.2";
      removefile = "45";
      libmalloc = "116.50.8";
      libresolv = "64";
      libplatform = "126.50.8";
      mDNSResponder = "765.50.9";
      libutil = "47.30.1";
      libunwind = "35.3";
      Libc = "1158.50.2";
      dtrace = "209.50.12";
      libpthread = "218.60.3";
      hfs = "366.70.1";
    };
    "osx-10.11.6" = {
      PowerManagement = "572.50.1";
      dtrace = "168";
      xnu = "3248.60.10";
      libpthread = "138.10.4";
      Libnotify = "150.40.1";
      objc4 = "680";
      eap8021x = "222.40.1";
      dyld = "360.22";
      architecture = "268";
      CommonCrypto = "60075.50.1";
      copyfile = "127";
      Csu = "85";
      ppp = "809.50.2";
      libclosure = "65";
      Libinfo = "477.50.4";
      Libsystem = "1226.10.1";
      removefile = "41";
      libresolv = "60";

      # Their release page is a bit of a mess here, so I'm going to lie a bit and say this version
      # is the right one, even though it isn't. The version I have here doesn't appear to be linked
      # to any OS releases, but Apple also doesn't mention mDNSResponder from 10.11 to 10.11.6, and
      # neither of those versions are publicly available.
      libplatform = "125";
      mDNSResponder = "625.41.2";

      # IOKit contains a set of packages with different versions, so we don't have a general version
      IOKit = "";

      libutil = "43";
      libunwind = "35.3";
      Librpcsvc = "26";
      developer_cmds = "62";
      network_cmds = "481.20.1";
      basic_cmds = "55";
      adv_cmds = "163";
      file_cmds = "264.1.1";
      shell_cmds = "187";
      system_cmds = "550.6";
      diskdev_cmds = "593";
      top = "108";
      text_cmds = "99";
    };
    "osx-10.11.5" = {
      Libc = "1082.50.1"; # 10.11.6 still unreleased :/
    };
    "osx-10.10.5" = {
      adv_cmds = "158";
      CF = "1153.18";
      ICU = "531.48";
      libdispatch = "442.1.4";
      Security = "57031.40.6";

      IOAudioFamily = "203.3";
      IOFireWireFamily = "458";
      IOFWDVComponents = "207.4.1";
      IOFireWireAVC = "423";
      IOFireWireSBP2 = "427";
      IOFireWireSerialBusProtocolTransport = "251.0.1";
      IOGraphics = "485.40.1";
      IOHIDFamily = "606.40.1";
      IONetworkingFamily = "101";
      IOSerialFamily = "74.20.1";
      IOStorageFamily = "182.1.1";
      IOBDStorageFamily = "14";
      IOCDStorageFamily = "51";
      IODVDStorageFamily = "35";
      IOKitUser = "1050.20.2";
    };
    "osx-10.9.5" = {
      launchd = "842.92.1";
      libauto = "185.5";
      Libc = "997.90.3"; # We use this, but not from here
      Libsystem = "1197.1.1";
      Security = "55471.14.18";
      security_dotmac_tp = "55107.1";

      IOStorageFamily = "172";
    };
    "osx-10.8.5" = {
      configd = "453.19";
      Libc = "825.40.1";
      IOUSBFamily = "630.4.5";
    };
    "osx-10.8.4" = {
      IOUSBFamily = "560.4.2";
    };
    "osx-10.7.4" = {
      Libm = "2026";
    };
    "osx-10.6.2" = {
      CarbonHeaders = "18.1";
    };
    "osx-10.5.8" = {
      adv_cmds = "119";
    };
    "dev-tools-7.0" = {
      bootstrap_cmds = "93";
    };
    "dev-tools-5.1" = {
      bootstrap_cmds = "86";
    };
    "dev-tools-3.2.6" = {
      bsdmake = "24";
    };
  };

  fetchApple' =
    pname: version: sha256:
    let
      # When cross-compiling, fetchurl depends on libiconv, resulting
      # in an infinite recursion without this. It's not clear why this
      # worked fine when not cross-compiling
      fetch = if pname == "libiconv" then stdenv.fetchurlBoot else fetchurl;
    in
    fetch {
      url = "https://github.com/apple-oss-distributions/${pname}/archive/refs/tags/${pname}-${version}.tar.gz";
      inherit sha256;
    };

  fetchApple =
    sdkName: sha256: pname:
    let
      version = versions.${sdkName}.${pname};
    in
    fetchApple' pname version sha256;

  appleDerivation'' =
    stdenv: pname: version: sdkName: sha256: attrs:
    stdenv.mkDerivation (
      finalAttrs:
      {
        inherit pname version;

        src = if attrs ? srcs then null else (fetchApple' pname version sha256);

        enableParallelBuilding = true;

        # In rare cases, APPLE may drop some headers quietly on new release.
        doInstallCheck = attrs ? appleHeaders;
        passAsFile = [ "appleHeaders" ];
        installCheckPhase = ''
          cd $out/include

          result=$(diff -u "$appleHeadersPath" <(find * -type f | sort) --label "Listed in appleHeaders" --label "Found in \$out/include" || true)

          if [ -z "$result" ]; then
            echo "Apple header list is matched."
          else
            echo >&2 "\
          Apple header list is inconsistent, please ensure no header file is unexpectedly dropped.
          $result
          "
            exit 1
          fi
        '';

      }
      // (if builtins.isFunction attrs then attrs finalAttrs else attrs)
      // {
        meta =
          (with lib; {
            platforms = platforms.darwin;
            license = licenses.apple-psl20;
          })
          // (attrs.meta or { });
      }
    );

  IOKitSpecs = {
    IOAudioFamily = fetchApple "osx-10.10.5" "sha256-frs2pm2OpGUOz68ZXsjktlyHlgn5oXM+ltbmAf//Cio=";
    IOFireWireFamily = fetchApple "osx-10.10.5" "sha256-V9fNeo/Wj9dm1/XM4hkOInnMk01M6c9QSjJs5zJKB60=";
    IOFWDVComponents = fetchApple "osx-10.10.5" "sha256-KenCX9C/Z2ErUK8tpKpm65gEmhn2NsXFxlzK7NKomaI=";
    IOFireWireAVC = fetchApple "osx-10.10.5" "sha256-Gd8+PK/mk+xEXgF8dGAx+3jsXv4NX1GiBFyjyrf6sTo=";
    IOFireWireSBP2 = fetchApple "osx-10.10.5" "sha256-Z3nP8pX1YG4Fbt7MrnqO06ihE9aYOex5Eib/rqOpoPk=";
    IOFireWireSerialBusProtocolTransport = fetchApple "osx-10.10.5" "sha256-zdYE0UCKiVhDRGdWaH8L51ArbYTnsQOmcN/OMmpNdFA=";
    IOGraphics = fetchApple "osx-10.10.5" "sha256-lXoW4sx3pyl5fg5Qde3sQi2i8rTLnpeCdDaTHjbfaMI=";
    IOHIDFamily = fetchApple "osx-10.10.5" "sha256-b+S1p3p5d8olYE18VrBns4euerVINaQSFEp34sko5rM=";
    IONetworkingFamily = fetchApple "osx-10.10.5" "sha256-NOpFOBKS6iwFj9DJxduZYZfZJuhDyBQw2QMKHbu7j40=";
    IOSerialFamily = fetchApple "osx-10.10.5" "sha256-hpYrgXsuTul4CYoYIjQjerfvQRqISM2tCcfVXlnjbZo=";
    IOStorageFamily = fetchApple "osx-10.9.5" "sha256-CeA4rHUrBKHsDeJU9ssIY9LQwDw09a+vQUyruosaLKA=";
    IOBDStorageFamily = fetchApple "osx-10.10.5" "sha256-gD52RKXGKWGga/QGlutxsgsPNSN6gcRfFQRT8v51N3E=";
    IOCDStorageFamily = fetchApple "osx-10.10.5" "sha256-+nyqH6lMPmIkDLYXNVSeR4vBYS165oyJx+DkCkKOGRg=";
    IODVDStorageFamily = fetchApple "osx-10.10.5" "sha256-Jy3UuRzdd0bBdhJgI/f8vLXh2GdGs1RVN3G2iEs86kQ=";
    # There should be an IOStreamFamily project here, but they haven't released it :(
    IOUSBFamily = fetchApple "osx-10.8.5" "sha256-FwgGoP97Sj47VGXMxbY0oUugKf7jtxAL1RzL6+315cU="; # This is from 10.8 :(
    IOUSBFamily_older =
      fetchApple "osx-10.8.4" "sha256-5apCsqtHK0EC8x1uPTTll43x69eal/nsokfS80qLlxs="
        "IOUSBFamily"; # This is even older :(
    IOKitUser = fetchApple "osx-10.10.5" "sha256-3UHM3g91v4RugmONbM+SAPr1SfoUPY3QPcTwTpt+zuY=";
    # There should be an IOVideo here, but they haven't released it :(
  };

  IOKitSrcs = lib.mapAttrs (
    name: value: if lib.isFunction value then value name else value
  ) IOKitSpecs;

in

# darwin package set
self:

let
  macosPackages_11_0_1 = import ./macos-11.0.1.nix { inherit applePackage'; };
  developerToolsPackages_11_3_1 = import ./developer-tools-11.3.1.nix { inherit applePackage'; };

  applePackage' =
    namePath: version: sdkName: sha256:
    let
      pname = builtins.head (lib.splitString "/" namePath);
      appleDerivation' = stdenv: appleDerivation'' stdenv pname version sdkName sha256;
      appleDerivation = appleDerivation' stdenv;
      callPackage = self.newScope {
        inherit appleDerivation' appleDerivation;
        python3 = pkgs.buildPackages.python3Minimal;
      };
    in
    callPackage (./. + "/${namePath}");

  applePackage =
    namePath: sdkName: sha256:
    let
      pname = builtins.head (lib.splitString "/" namePath);
      version = versions.${sdkName}.${pname};
    in
    applePackage' namePath version sdkName sha256;

  # Only used for bootstrapping. It’s convenient because it was the last version to come with a real makefile.
  adv_cmds-boot =
    applePackage "adv_cmds/boot.nix" "osx-10.5.8" "sha256-/OJLNpATyS31W5nWfJgSVO5itp8j55TRwG57/QLT5Fg="
      { };

in

developerToolsPackages_11_3_1
// macosPackages_11_0_1
// {
  # TODO: shorten this list, we should cut down to a minimum set of bootstrap or necessary packages here.

  inherit (adv_cmds-boot) ps locale;
  architecture =
    applePackage "architecture" "osx-10.11.6" "sha256-cUKeMx6mOAxBSRHIdfzsrR65Qv86m7+20XvpKqVfwVI="
      { };
  bsdmake =
    applePackage "bsdmake" "dev-tools-3.2.6" "sha256-CW8zP5QZMhWTGp+rhrm8oHE/vSLsRlv1VRAGe1OUDmI="
      { };
  CarbonHeaders =
    applePackage "CarbonHeaders" "osx-10.6.2" "sha256-UNaHvxzYzEBnYYuoMLqWUVprZa6Wqn/3XleoSCco050="
      { };
  CommonCrypto =
    applePackage "CommonCrypto" "osx-10.12.6" "sha256-FLgODBrfv+XsGaAjddncYAm/BIJJYw6LcwX/z7ncKFM="
      { };
  configd =
    applePackage "configd" "osx-10.8.5" "sha256-6I3FWNjTgds5abEcZrD++s9b+P9a2+qUf8KFAb72DwI="
      {
        Security =
          applePackage "Security/boot.nix" "osx-10.9.5" "sha256-7qr0IamjCXCobIJ6V9KtvbMBkJDfRCy4C5eqpHJlQLI="
            { };
        inherit (pkgs.darwin.apple_sdk.libs) xpc;
      };
  copyfile =
    applePackage "copyfile" "osx-10.12.6" "sha256-uHqLFOIpXK+n0RHyOZzVsP2DDZcFDivKCnqHBaXvHns="
      { };
  Csu = applePackage "Csu" "osx-10.11.6" "sha256-h6a/sQMEVeFxKNWAPgKBXjWhyL2L2nvX9BQUMaTQ6sY=" { };
  dtrace =
    applePackage "dtrace" "osx-10.12.6" "sha256-Icr22ozixHquI0kRB2XZ+LlxD6V46sJHsHy4L/tDXZg="
      { };
  dyld = applePackage "dyld" "osx-10.12.6" "sha256-JmKnOZtBPf96zEx7vhYHLBSTOPyKN71IdYE3R0IeJww=" { };
  eap8021x =
    applePackage "eap8021x" "osx-10.11.6" "sha256-54P3+YhVhOanoZQoqswDnr/GbR/AdEERse135nyuIQo="
      { };
  IOKit = applePackage "IOKit" "osx-10.11.6" "" { inherit IOKitSrcs; };
  launchd =
    applePackage "launchd" "osx-10.9.5" "sha256-dmV0UK7hG9wvTr+F4Z47nCFXcVZCV+cQ46WbE0DBtJs="
      { };
  libauto =
    applePackage "libauto" "osx-10.9.5" "sha256-GnRcKq8jRbEsI/PSDphwUjWtpEIEcnLlQL9yxYLgSsU="
      { };
  Libc = applePackage "Libc" "osx-10.12.6" "sha256-LSsL7S3KFgGU9qjK4atu/4wBh8ftgfsk6JOvg+ZTZOY=" {
    Libc_10-9 = fetchFromGitHub {
      owner = "apple-oss-distributions";
      repo = "Libc";
      rev = "Libc-997.90.3";
      hash = "sha256-B18RNO+Rai5XE52TKdJV7eknosTZ+bRERkiU12d/kPU=";
    };
  };
  libclosure =
    applePackage "libclosure" "osx-10.11.6" "sha256-L5rQ+UBpf3B+W1U+gZKk7fXulslHsc8lxnCsplV+nr0="
      { };
  libdispatch =
    applePackage "libdispatch" "osx-10.10.5" "sha256-jfAEk0OLrJa9AIZVikIoHomd+l+4rCfc320Xh50qK5M="
      { };
  Libinfo =
    applePackage "Libinfo" "osx-10.11.6" "sha256-6F7wiwerv4nz/xXHtp1qCHSaFzZgzcRN+jbmXA5oWOQ="
      { };
  Libm = applePackage "Libm" "osx-10.7.4" "sha256-KjMETfT4qJm0m0Ux/F6Rq8bI4Q4UVnFx6IKbKxXd+Es=" { };
  Libnotify =
    applePackage "Libnotify" "osx-10.12.6" "sha256-6wvMBxAUfiYcQtmlfYCj1d3kFmFM/jdboTd7hRvi3e4="
      { };
  libmalloc =
    if stdenv.isx86_64 then
      applePackage "libmalloc" "osx-10.12.6" "sha256-brfG4GEF2yZipKdhlPq6DhT2z5hKYSb2MAmffaikdO4=" { }
    else
      macosPackages_11_0_1.libmalloc;
  libplatform =
    if stdenv.isx86_64 then
      applePackage "libplatform" "osx-10.12.6" "sha256-6McMTjw55xtnCsFI3AB1osRagnuB5pSTqeMKD3gpGtM=" { }
    else
      macosPackages_11_0_1.libplatform;
  libpthread =
    applePackage "libpthread" "osx-10.12.6" "sha256-QvJ9PERmrCWBiDmOWrLvQUKZ4JxHuh8gS5nlZKDLqE8="
      { };
  libresolv =
    applePackage "libresolv" "osx-10.12.6" "sha256-FtvwjJKSFX6j9APYPC8WLXVOjbHLZa1Gcoc8yxLy8qE="
      { };
  Libsystem =
    applePackage "Libsystem" "osx-10.12.6" "sha256-zvRdCP//TjKCGAqm/5nJXPppshU1cv2fg/L/yK/olGQ="
      { };
  libutil =
    applePackage "libutil" "osx-10.12.6" "sha256-4PFuk+CTLwvd/Ll9GLBkiIM0Sh/CVaiKwh5m1noheRs="
      { };
  libunwind =
    applePackage "libunwind" "osx-10.12.6" "sha256-CC0sndP/mKYe3dZu3v7fjuDASV4V4w7dAcnWMvpoquE="
      { };
  mDNSResponder =
    applePackage "mDNSResponder" "osx-10.12.6" "sha256-ddZr6tropkpdMJhq/kUlm3OwO8b0yxtkrMpwec8R4FY="
      { };
  objc4 =
    applePackage "objc4" "osx-10.12.6" "sha256-ZsxRpdsfv3Dxs7yBBCkjbKXKR6aXwkEpxc1XYXz7ueM="
      { };
  ppp = applePackage "ppp" "osx-10.12.6" "sha256-M1zoEjjeKIDUEP6ACbpUJk3OXjobw4g/qzUmxGdX1J0=" { };
  removefile =
    applePackage "removefile" "osx-10.12.6" "sha256-UpNk27kGXnZss1ZXWVJU9jLz/NW63ZAZEDLhyCYoi9M="
      { };
  xnu =
    if stdenv.isx86_64 then
      applePackage "xnu" "osx-10.12.6" "sha256-C8TPQlUT3RbzAy8YnZPNtr70hpaVG9Llv0h42s3NENI=" { }
    else
      macosPackages_11_0_1.xnu;
  hfs = applePackage "hfs" "osx-10.12.6" "sha256-eGi18HQFJrU5UHoBOE0LqO5gQ0xOf8+OJuAWQljfKE4=" { };
  Librpcsvc =
    applePackage "Librpcsvc" "osx-10.11.6" "sha256-YHbGws901xONzAbo6sB5zSea4Wp0sgYUJ8YgwVfWxnE="
      { };
  adv_cmds =
    applePackage "adv_cmds" "osx-10.11.6" "sha256-Ztp8ALWcviEpthoiY8ttWzGI8OcsLzsULjlqe8GIzw8="
      { };
  basic_cmds =
    applePackage "basic_cmds" "osx-10.11.6" "sha256-BYPPTg4/7x6RPs0WwwQlkNiZxxArV+7EVe6bM+a/I6Q="
      { };
  developer_cmds =
    applePackage "developer_cmds" "osx-10.11.6" "sha256-h0wMVlS6QdRvKOVJ74W9ziHYGApjvnk77AIR6ukYBRo="
      { };
  diskdev_cmds =
    applePackage "diskdev_cmds" "osx-10.11.6" "sha256-VX+hcZ7JhOA8EhwLloPlM3Yx79RXp9OYHV9Mi10uw3Q="
      {
        macosPackages_11_0_1 = macosPackages_11_0_1;
      };
  network_cmds =
    if stdenv.isx86_64 then
      applePackage "network_cmds" "osx-10.11.6" "sha256-I89CLIswGheewOjiNZwQTgWvWbhm0qtB5+KUqzxnQ5M=" { }
    else
      macosPackages_11_0_1.network_cmds;
  file_cmds =
    applePackage "file_cmds" "osx-10.11.6" "sha256-JYy6HwmultKeZtLfaysbsyLoWg+OaTh7eJu54JkJC0Q="
      { };
  shell_cmds =
    applePackage "shell_cmds" "osx-10.11.6" "sha256-kmEOprkiJGMVcl7yHkGX8ymk/5KjE99gWuF8j2hK5hY="
      { };
  system_cmds =
    applePackage "system_cmds" "macos-14.3" "sha256-qFp9nkzsq9uQ7zoyfvO+3gvDlc7kaPvn6luvmO/Io30="
      { };
  text_cmds =
    applePackage "text_cmds" "osx-10.11.6" "sha256-KSebU7ZyUsPeqn51nzuGNaNxs9pvmlIQQdkWXIVzDxw="
      { };
  top = applePackage "top" "osx-10.11.6" "sha256-jbz64ODogtpNyLpXGSZj1jCBdFPVXcVcBkL1vc7g5qQ=" { };
  PowerManagement =
    applePackage "PowerManagement" "osx-10.11.6" "sha256-bYGtYnBOcE5W03AZzfVTJXPZ6GgryGAMt/LgLPxFkVk="
      { };

  # `configdHeaders` can’t use an override because `pkgs.darwin.configd` on aarch64-darwin will
  # be replaced by SystemConfiguration.framework from the macOS SDK.
  configdHeaders =
    applePackage "configd" "osx-10.8.5" "sha256-6I3FWNjTgds5abEcZrD++s9b+P9a2+qUf8KFAb72DwI="
      {
        headersOnly = true;
        Security = null;
        xpc = null;
      };
  libutilHeaders = pkgs.darwin.libutil.override { headersOnly = true; };
  hfsHeaders = pkgs.darwin.hfs.override { headersOnly = true; };
  libresolvHeaders = pkgs.darwin.libresolv.override { headersOnly = true; };

  # TODO(matthewbauer):
  # To be removed, once I figure out how to build a newer Security version.
  Security =
    applePackage "Security/boot.nix" "osx-10.9.5" "sha256-7qr0IamjCXCobIJ6V9KtvbMBkJDfRCy4C5eqpHJlQLI="
      { };
}
