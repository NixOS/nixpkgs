{ stdenv, fetchgit, fetchurl, python, ninja, libevent, xdg-user-dirs }:

let
  date = "20161008";

  sourceTree = {
    "src/base" = {
      rev = "e71a514e60b085cc92bf6ef951ec329f52c79f9f";
      sha256 = "0zycbssmd2za0zij8czcs1fr66fi12f1g5ysc8fzkf8khbs5h6a9";
    };
    "src/build" = {
      rev = "17093d45bf738e9ae4b6294492860ee65218a657";
      sha256 = "0i9py78c3f46sc789qvdhmgjgyrghysbqjgr67iypwphw52jv2dz";
    };
    "src/tools/gn" = {
      rev = "9ff32cf3f1f4ad0212ac674b6303e7aa68f44f3f";
      sha256 = "14jr45k5fgcqk9d18fd77sijlqavvnv0knndh74zyb0b60464hz1";
    };
    "testing/gtest" = {
      rev = "585ec31ea716f08233a815e680fc0d4699843938";
      sha256 = "0csn1cza66851nmxxiw42smsm3422mx67vcyykwn0a71lcjng6rc";
    };
  };

  mkDepend = path: attrs: fetchgit {
    url = "https://chromium.googlesource.com/chromium/${path}";
    inherit (attrs) rev sha256;
  };

in stdenv.mkDerivation rec {
  name = "gn-${version}";
  version = "0.0.0.${date}";

  unpackPhase = ''
    ${with stdenv.lib; concatStrings (mapAttrsToList (path: sha256: ''
      dest=source/${escapeShellArg (removePrefix "src/" path)}
      mkdir -p "$(dirname "$dest")"
      cp --no-preserve=all -rT ${escapeShellArg (mkDepend path sha256)} "$dest"
    '') sourceTree)}
    ( mkdir -p source/third_party
      cd source/third_party
      unpackFile ${xdg-user-dirs.src}
      mv * xdg_user
    )
  '';

  sourceRoot = "source";

  postPatch = ''
    # GN's bootstrap script relies on shebangs (which are relying on FHS paths),
    # except when on Windows. So instead of patchShebang-ing it, let's just
    # force the same behaviour as on Windows.
    sed -i -e '/^def  *check_call/,/^[^ ]/ {
      s/is_win/True/
    }' tools/gn/bootstrap/bootstrap.py

    # Patch out Chromium-bundled libevent and xdg_user_dirs
    sed -i -e '/static_libraries.*libevent/,/^ *\]\?[})]$/d' \
      tools/gn/bootstrap/bootstrap.py
  '';

  NIX_LDFLAGS = "-levent";

  nativeBuildInputs = [ python ninja ];
  buildInputs = [ libevent ];

  buildPhase = ''
    python tools/gn/bootstrap/bootstrap.py -v -s --no-clean
  '';

  installPhase = ''
    install -vD out_bootstrap/gn "$out/bin/gn"
  '';

  meta = {
    description = "A meta-build system that generates NinjaBuild files";
    homepage = "https://chromium.googlesource.com/chromium/src/tools/gn/";
    license = stdenv.lib.licenses.bsd3;
  };
}
