{ stdenv, lib, gox, gotools, buildGoPackage, fetchFromGitHub
, fetchgit, fetchhg, fetchbzr, fetchsvn
, writeScript, coreutils, jq, curl, git, bash, gnugrep, gnused, nix-prefetch-git, findutils, gawk
}:

let
  deps = import ./deps.nix {
    inherit stdenv lib gox gotools buildGoPackage fetchgit fetchhg fetchbzr fetchsvn;
  };
in stdenv.mkDerivation rec {
  name = "packer-${version}";
  version = deps.version;

  src = deps.out;

  buildInputs = [ src.go gox gotools ];

  configurePhase = ''
    export GOPATH=$PWD/share/go
    export XC_ARCH=$(go env GOARCH)
    export XC_OS=$(go env GOOS)

    mkdir $GOPATH/bin

    cd $GOPATH/src/github.com/mitchellh/packer

    # Don't fetch the deps
    substituteInPlace "Makefile" --replace ': deps' ':'

    # Avoid using git
    sed \
      -e "s|GITBRANCH:=.*||" \
      -e "s|GITSHA:=.*|GITSHA=${src.rev}|" \
      -i Makefile
    sed \
      -e "s|GIT_COMMIT=.*|GIT_COMMIT=${src.rev}|" \
      -e "s|GIT_DIRTY=.*|GIT_DIRTY=|" \
      -i "scripts/build.sh"
  '';

  buildPhase = ''
    make generate releasebin
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/* $out/bin # */
  '';

  passthru.updateScript = writeScript "update-packer" ''
    #!${bash}/bin/bash
    set -euo pipefail

    PATH=${coreutils}/bin:${jq}/bin:${git}/bin:${gnugrep}/bin:${gnused}/bin:${nix-prefetch-git}/bin:${findutils}/bin:${gawk}/bin:${curl}/bin
    GITHUB_SLUG=mitchellh/packer
    REPO_BASE=github.com/$GITHUB_SLUG
    REPO=https://$REPO_BASE

    # Fetch the latest version from upstream git repo
    latest_rev_and_ver() {
      # Example ls-remote output
      # 1fc1a7a7f1fc7058495c52f101cd3a498958781d        refs/tags/v0.9.0
      # d7f5f0283158b0c478c20f1323203c5aa0dc13dc        refs/tags/v0.9.0^{}
      # Function will return:
      # 1fc1a7a7f1fc7058495c52f101cd3a498958781d        0.9.0
      git ls-remote $REPO 'refs/tags/*' | grep -vF '^{}' | sort -k 2 --version-sort --reverse | sed -e 's,refs/tags/v,,' | head -n 1 # */
    }

    # packer lists all it's external go dependencies in vendor/vendor.json
    # this function returns list of those dependencies as a series of line like:
    #
    # some.domain/some.go.path git-revision-id
    vendor_packages_list() {
      cat $VENDOR | jq --raw-output '.package[] | "\(.revision)\t\(.path)"' | sort
    }

    # In 0.12.1 there is different git revisions of crypto used for different go paths.
    # This finds out the most frequently used revison
    choose_x_crypto_revision() {
      vendor_packages_list | grep -F 'golang.org/x/crypto' | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
    }

    # Different hacks. Currently only one that forces all crypto dependencies to use a single git revision.
    fixup_revisions() {
      local force_crypto=$(choose_x_crypto_revision)
      sed -e 's,^.*\(golang.org/x/crypto/\),'$force_crypto'\t\1,'
    }

    # find all go package paths that correspond to unique git
    # repositories. Assumption is that we can group all dependencies
    # that reference the same git revision id, find out their common
    # prefix, and use only this value as an `extraSrcs`.
    vendor_packages() {
      local last_rev=
      local common_path=
      local rev
      local path

      while read rev path ; do
        if [[ $last_rev != $rev ]]; then
          if [[ -n $last_rev ]]; then
            echo -e "$last_rev\t$common_path" | sed -e 's,/$,,'
          fi
          common_path=$path
          last_rev=$rev
        else
          common_path=$(printf "%s\n%s\n" "$common_path" "$path" | sed -e 'N;s/^\(.*\).*\n\1.*$/\1/')
        fi
      done < <(vendor_packages_list | fixup_revisions | sort)
    }

    # A collection of hacks to convert go package path to a (git repo
    # url, new package path) pair. new package path is needed if
    # original one is acutally pointing into some subdirectory in the
    # git repo.
    # TODO: Find out how 'go get' does it
    path_to_repo() {
      local path="$1"
      case "$path" in
        github.com/*) #*/
          # Remove all but 2 first path components, add https
          echo "$path" | sed -e 's,github.com/\([^/]\+\)/\([^/]\+\).*,https://github.com/\1/\2\tgithub.com/\1/\2,'
          ;;
        golang.org/x/*) #*/
          echo "$path" | sed -e 's,golang.org/x/\([^/]\+\).*,https://go.googlesource.com/\1\tgolang.org/x/\1,'
          ;;
        google.golang.org/cloud)
          echo -e "https://code.googlesource.com/gocloud\t$path"
          ;;
        google.golang.org/api)
          echo -e "https://code.googlesource.com/google-api-go-client\t$path"
          ;;
        google.golang.org/appengine)
          echo -e "https://github.com/golang/appengine\t$path"
          ;;
        gopkg.in/*)  # */
          echo "$path" | sed -e 's,^,https://,' -e 's,$,\t'$path','
          ;;
        *)
          echo "Unknown package path: $path" 1>&2
          return 1
        ;;
      esac
    }

    print_header() {
      local version=$1
      local ref=$2
      cat <<EOF
    { stdenv, lib, gox, gotools, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

    buildGoPackage rec {
      name = "packer-$version";
      version = "$version";
      rev = "$ref";

      buildInputs = [ gox gotools ];

      goPackagePath = "$REPO_BASE";

    $(fetchgit_src $REPO $ref | prefix "  ")

      extraSrcs = [
    EOF
    }

    # Produces a "src = fetchgit { .. }" string for a given git repo url and revision.
    # nix-prefetch-git output is massaged a bit to achieve desired result.
    fetchgit_src() {
      echo -n "src = fetchgit "
      nix-prefetch-git "$1" "$2" | grep -vE '"(date|fetchSubmodules)":' | sed -e 's/"\([^"]\+\)": \(".*"\),/\1 = \2;/' | sed -e 's,},};,' # "
    }

    print_footer() {
    cat <<EOF
      ];
    }
    EOF
    }

    print_extra_pkg() {
      local path=$1
      local ref=$2
      local repo=$3
      echo    "{"
      echo    "  goPackagePath = \"$path\";"
      echo    ""
      fetchgit_src $repo $ref | prefix "  "
      echo "}"
    }

    # prepend given prefix to every line of its input. Used for pretty-printing.
    prefix() {
      sed -r -e "s/^/$1/" -e 's/^\s+$//'
    }

    read latest_rev latest_ver < <(latest_rev_and_ver)

    if [[ $latest_ver == ${version} ]]; then
      exit 0
    fi

    echo "Upgrading from ${version} to $latest_ver"
    VENDOR=$(mktemp)
    trap "rm -rf $VENDOR" EXIT
    curl https://raw.githubusercontent.com/$GITHUB_SLUG/v$latest_ver/vendor/vendor.json -o $VENDOR

    OUT=pkgs/development/tools/packer/deps.nix

    print_header $latest_ver $latest_rev > $OUT

    while read pkg_ref pkg_path ; do
      read repo new_path < <(path_to_repo $pkg_path)
      echo $pkg_path '->' $new_path '=' $repo
      print_extra_pkg $new_path $pkg_ref $repo | prefix "    " >> $OUT
    done < <(vendor_packages | sort -k 2)

    print_footer >> $OUT
  '';

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
