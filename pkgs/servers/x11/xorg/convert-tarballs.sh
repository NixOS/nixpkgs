#!/usr/bin/env bash

aliasFile="xorg-aliases.nix"
callFile="call-xorg.nix"
rm $aliasFile
rm $callFile
rm -rf packages
mkdir -p packages
urls="$(cat ./tarballs.list)"

echo 'self: super:' >> $aliasFile
echo '{' >> $aliasFile
echo '{ pixman }:' >> $callFile
echo 'self: with self; {' >> $callFile
echo '  inherit pixman;' >> $callFile

for url in $urls; do
    #echo $url
    if [[ $url =~ gitlab ]]; then
        if [[ $url =~ xf86-video-ati ]]; then
            echo "  xf86videoati = self.xf86-video-ati;" >> $aliasFile
            echo "  xf86-video-ati = callPackage ./packages/xf86-video-ati.nix { };" >> $callFile
            cat >> ./packages/xf86-video-ati.nix << EOF
{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-ati";
  version = "$version";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-ati";
    rev = "5eba006e4129e8015b822f9e1d2f1e613e252cda";
    hash = "sha256-dlJi2YUK/9qrkwfAy4Uds4Z4a82v6xP2RlCOsEHnidg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
EOF
        elif [[ $url =~ xf86-video-nouveau ]]; then
            echo "  xf86videonouveau = self.xf86-video-nouveau;" >> $aliasFile
            echo "  xf86-video-nouveau = callPackage ./packages/xf86-video-nouveau.nix { };" >> $callFile
            cat >> ./packages/xf86-video-nouveau.nix << EOF
{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nouveau";
  version = "$version";
  builder = ./builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nouveau";
    rev = "3ee7cbca8f9144a3bb5be7f71ce70558f548d268";
    hash = "sha256-WmGjI/svtTngdPQgqSfxeR3Xpe02o3uB2Y9k19wqJBE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
EOF
        fi
        continue
    fi

    if true; then
    #if [[ $url =~ lib ]]; then
        bname="$(basename -s ".tgz" "$(basename -s ".tar.gz" "$(basename -s ".tar.bz2" "$(basename -s ".tar.xz" "$url")")")")"
        bnameWithoutVersion=$(rev <<< "$bname" | cut -d"-" -f2- | rev)
        filename="$bnameWithoutVersion-$bname"
        group="$(basename "$(dirname "$url")")"
        reponame="$bnameWithoutVersion"
        tagname="$bname"
        owner="xorg"
        version=$(rev <<< "$bname" | cut -d"-" -f1 | rev)

        if [[ $bnameWithoutVersion == "x11perf" ]]; then
            group="test"
        fi


        if [[ $url =~ /font/ ]]; then
            # the repos don't have font- prefixes
            reponame="${bnameWithoutVersion#font-}"
        fi

        if [[ $bname =~ xbitmaps|xcursor-themes ]]; then
            reponame="${bnameWithoutVersion#x}"
            # cursor-themes -> cursors
            reponame="${reponame/%-themes/s}"
        fi

        if [[ $bname =~ xtrans ]]; then
            reponame="libxtrans"
        fi

        if [[ $bnameWithoutVersion == "xcb-proto" ]]; then
            reponame="xcbproto"
        fi

        if [[ $bnameWithoutVersion == "util-macros" ]]; then
            reponame="macros"
        fi

        if [[ $bname =~ vboxvideo ]]; then
            reponame="xf86-video-vbox"
            filename="xf86-video-vbox-xf86-video-vboxvideo-${version}"
        fi

        if [[ $bnameWithoutVersion == "xorg-server" ]]; then
            reponame="xserver"
            group=""
            filename="$reponame-$bname"
        fi

        if [[ $bnameWithoutVersion == "xkeyboard-config" ]]; then
            owner="xkeyboard-config"
            group="xkbdesc"
        fi

        if [[ $bnameWithoutVersion == "xf86-video-intel" ]]; then
            tagname="$version"
        fi

        if [[ $bnameWithoutVersion =~ "xcb-util-" ]]; then
            reponame="${bnameWithoutVersion/#xcb-util/libxcb}"
            filename="$reponame-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util" ]]; then
            reponame="libxcb-util"
            filename="$reponame-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util-renderutil" ]]; then
            reponame="libxcb-render-util"
            filename="$reponame-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util" ]]; then
            reponame="libxcb-util"
            filename="$reponame-$bname"
        fi

        if [[ $bnameWithoutVersion == "xorg-cf-files" ]]; then
            reponame="cf"
        fi

        if [[ $bnameWithoutVersion == "libpthread-stubs" ]]; then
            reponame="pthread-stubs"
            #filename="$reponame-$bname"
            # we're still at 0.4
            # https://gitlab.freedesktop.org/xorg/lib/pthread-stubs/-/archive/0.4/pthread-stubs-0.4.tar.bz2
            # vs 0.5 url
            # https://gitlab.freedesktop.org/xorg/lib/pthread-stubs/-/archive/libpthread-stubs-0.5/pthread-stubs-libpthread-stubs-0.5.tar.bz2
            # so remove the below if updated
            #filename="$reponame-$version"
            #tagname="$version"
        fi

        if [[ $group == "xcb" ]]; then
            group="lib"
        fi

        groupforurl="${group:+/$group}"
        giturl="https://gitlab.freedesktop.org/$owner$groupforurl/$reponame"

        if [[ $bnameWithoutVersion =~ "-" ]]; then
            aAlias="${bnameWithoutVersion//-/}"
            echo "  $aAlias = self.$bnameWithoutVersion;" >> $aliasFile
        fi

        echo "  $bnameWithoutVersion = callPackage ./packages/$bnameWithoutVersion.nix { };" >> $callFile

        echo -n "$bname: "
        # GIT_ASKPASS is so git does not prompt for user and pass when the repo doesn't exist
        if lsremote="$(GIT_ASKPASS="echo" git ls-remote "${giturl}.git" 2>/dev/null)"; then
            echo -n "found "
            newurl="${giturl}/-/archive/$tagname/$filename.tar.bz2"
            echo "$newurl"

            # $reponame is not used because no distro uses it, instead they use the name in the AC_INIT call in configure.ac, which is $bnameWithoutVersion
            hash=$(nix-prefetch-url "https://gitlab.freedesktop.org/api/v4/projects/${owner}%2F${group}%2F${reponame}/repository/archive.tar.gz?sha=refs%2Ftags%2F${bname}" --name source --unpack --type sha256 | xargs nix hash to-sri --type sha256)
            cat >> "./packages/$bnameWithoutVersion.nix" << EOF
{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "$bnameWithoutVersion";
  version = "$version";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "$owner";
    owner = "$group";
    repo = "$reponame";
    rev = "refs/tags/$bname";
    hash = "$hash";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
EOF
        else
            echo "not found"
            hash=$(nix-prefetch-url "$url" --name source --type sha256 | xargs nix hash to-sri --type sha256)
                cat >> "./packages/$bnameWithoutVersion.nix" << EOF
{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "$bnameWithoutVersion";
  version = "$version";
  builder = ../builder.sh;

  src = fetchurl {
    url = "$url";
    hash = "$hash";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
EOF
        fi
    fi
done
echo '}' >> $aliasFile
echo '}' >> $callFile


# TODO fix src without hash manually
