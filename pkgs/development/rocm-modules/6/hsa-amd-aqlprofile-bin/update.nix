{
  lib,
  writeScript,
}:

{ version }:

let
  prefix = "hsa-amd-aqlprofile";
  extVersion = lib.strings.concatStrings (
    lib.strings.intersperse "0" (lib.versions.splitVersion version)
  );
  major = lib.versions.major version;
  minor = lib.versions.minor version;
  patch = lib.versions.patch version;

  updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts
    apt="https://repo.radeon.com/rocm/apt"
    pool="pool/main/h/${prefix}/"
    url="$apt/latest/$pool"
    res="$(curl -sL "$url")"
    deb="${prefix}$(echo "$res" | grep -o -P "(?<=href=\"${prefix}).*(?=\">)" | tail -1)"
    patch="${patch}"

    # Try up to 10 patch versions
    for i in {1..10}; do
      ((patch++))
      extVersion="$(echo "$deb" | grep -o -P "(?<=\.....).*(?=\..*-)")"

      if (( ''${#extVersion} == 6 )) && (( $extVersion <= ${extVersion} )); then
        url="https://repo.radeon.com/rocm/apt/${major}.${minor}.$patch/pool/main/h/${prefix}/"
        res="$(curl -sL "$url")"
        deb="${prefix}$(echo "$res" | grep -o -P "(?<=href=\"${prefix}).*(?=\">)" | tail -1)"
      else
        break
      fi
    done

    extVersion="$(echo $deb | grep -o -P "(?<=\.....).*(?=\..*-)")"
    version="$(echo $extVersion | sed "s/0/./1" | sed "s/0/./1")"
    IFS='.' read -a version_arr <<< "$version"

    if (( ''${version_arr[0]} > 6 )); then
      echo "'rocmPackages_6.${prefix}-bin' is already at it's maximum allowed version.''\nAny further upgrades should go into 'rocmPackages_X.${prefix}-bin'." 1>&2
      exit 1
    fi

    if (( ''${#extVersion} == 6 )); then
      repoVersion="$version"

      if (( ''${version:4:1} == 0 )); then
        repoVersion=''${version:0:3}
      fi

      update-source-version rocmPackages_6.${prefix}-bin "$version" "" "$apt/$repoVersion/$pool$deb" --ignore-same-hash
    fi
  '';
in
[ updateScript ]
