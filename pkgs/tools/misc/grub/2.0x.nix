{ lib, stdenv, fetchurl, flex, bison, python3, autoreconfHook, gnulib, libtool, bash
, gettext, ncurses, libusb-compat-0_1, freetype, qemu, lvm2, unifont, pkg-config
, buildPackages
, fetchpatch
, pkgsBuildBuild
, nixosTests
, fuse # only needed for grub-mount
, runtimeShell
, zfs ? null
, efiSupport ? false
, zfsSupport ? false
, xenSupport ? false
, kbdcompSupport ? false, ckbcomp
}:

let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "arm64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  canEfi = lib.any (system: stdenv.hostPlatform.system == system) (lib.mapAttrsToList (name: _: name) efiSystemsBuild);
  inPCSystems = lib.any (system: stdenv.hostPlatform.system == system) (lib.mapAttrsToList (name: _: name) pcSystems);

  version = "2.06";

in (

assert efiSupport -> canEfi;
assert zfsSupport -> zfs != null;
assert !(efiSupport && xenSupport);

stdenv.mkDerivation rec {
  pname = "grub";
  inherit version;

  src = fetchurl {
    url = "mirror://gnu/grub/grub-${version}.tar.xz";
    sha256 = "sha256-t56kSvkbk9F80/6Ava5u1DdwZ4qaWuGSzOqAPrtlfuE=";
  };

  patches = [
    ./fix-bash-completion.patch
    (fetchpatch {
      name = "Add-hidden-menu-entries.patch";
      # https://lists.gnu.org/archive/html/grub-devel/2016-04/msg00089.html
      url = "https://marc.info/?l=grub-devel&m=146193404929072&q=mbox";
      sha256 = "00wa1q5adiass6i0x7p98vynj9vsz1w0gn1g4dgz89v35mpyw2bi";
    })

    # Pull upstream patch to fix linkage against binutils-2.36.
    (fetchpatch {
      name = "binutils-2.36.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=b98275138bf4fc250a1c362dfd2c8b1cf2421701";
      sha256 = "001m058bsl2pcb0ii84jfm5ias8zgzabrfy6k2cc9w6w1y51ii82";
    })
    # Properly handle multiple initrd paths in 30_os-prober
    # Remove this patch once a new release is cut
    (fetchpatch {
      name = "Properly-handle-multiple-initrd-paths-in-os-prober.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=000b5cd04fd228f9741f5dca0491636bc0b89eb8";
      sha256 = "sha256-Mex3qQ0lW7ZCv7ZI7MSSqbylJXZ5RTbR4Pv1+CJ0ciM=";
    })
    (fetchpatch {
      name = "CVE-2021-3981.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=0adec29674561034771c13e446069b41ef41e4d4";
      sha256 = "sha256-3vkvWjcSv0hyY2EX3ig2EXEe+XLiRsXYlcd5kpY4wXw=";
    })
    # June 2022 security patches
    # https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.1.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1469983ebb9674753ad333d37087fb8cb20e1dce";
      sha256 = "sha256-oB4S0jvIXsDPcjIz1E2LKm7gwdvZjywuI1j0P6JQdJg=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.2.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=14ceb3b3ff6db664649138442b6562c114dcf56e";
      sha256 = "sha256-mKe8gzd0U4PbV8z3TWCdvv7UugEgYaVIkB4dyMrSGEE=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.3.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=04c86e0bb7b58fc2f913f798cdb18934933e532d";
      sha256 = "sha256-sA+PTlk4hwYOVKRZBHkEskabzmsf47Hi4h3mzWOFjwM=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.4.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=6fe755c5c07bb386fda58306bfd19e4a1c974c53";
      sha256 = "sha256-8zmFocUfnjSyhYitUFDHoilHDnm1NJmhcKwO9dueV3k=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.5.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=f1ce0e15e70ea1aafcfa26ad93e7585f65783c6f";
      sha256 = "sha256-Wrlam6CRPUAHbKqe/X1YLcRxJ2LQTtmQ/Y66gxUlqK4=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.6.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=5bff31cdb6b93d738f850834e6291df1d0b136fa";
      sha256 = "sha256-ReLWSePXjRweymsVAL/uoBgYMWt9vRDcY3iXlDNZT0w=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.7.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=347880a13c239b4c2811c94c9a7cf78b607332e3";
      sha256 = "sha256-07hpHuJFw95xGoJ/6ej7i6HlCFb2QRxP3arvRjKW4uU=";
    })
    ## Needed to apply patch 8
    (fetchpatch {
      name = "video-remove-trailing-whitespaces.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1f48917d8ddb490dcdc70176e0f58136b7f7811a";
      sha256 = "sha256-/yf/LGpwYcQ36KITzmiFfg4BvhcApKbrlFzjKK8V2kI=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.8.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=e623866d9286410156e8b9d2c82d6253a1b22d08";
      sha256 = "sha256-zFxP6JY5Q9s3yJHdkbZ2w+dXFKeOCXjFnQKadB5HLCg=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.9.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=210245129c932dc9e1c2748d9d35524fb95b5042";
      sha256 = "sha256-FyZhdTlcRVmn7X2hv93RhWP7NOoEMb7ib/DWveyz3Ew=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.10.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=690bee69fae6b4bd911293d6b7e56774e29fdf64";
      sha256 = "sha256-nOAXxebCW/s5M6sjPKdSdx47/PcH1lc0yYT0flVwoC8=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.11.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d5caac8ab79d068ad9a41030c772d03a4d4fbd7b";
      sha256 = "sha256-9fGJJkgZ6+E01MJqVTR1qFITx9EAx41Hv9QNfdqBgu0=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.12.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=768ef2199e0265cf455b154f1a80a612f02274c8";
      sha256 = "sha256-2/JJJux5vqXUc77bi3aXRy8NclbvyD/0e6UN8/6Ui3c=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.13.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=166a4d61448f74745afe1dac2f2cfb85d04909bf";
      sha256 = "sha256-XxTZ8P8qr4qEXELdHwaRACPeIZ/iixlATLB5RvVQsC8=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.14.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=22a3f97d39f6a10b08ad7fd1cc47c4dcd10413f6";
      sha256 = "sha256-bzB2gmGvWR2ylvMw779KQ/VHBBMsDNbG96eg9qQlljA=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.15.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=830a9628b2c9e1b6388af624aaf4a80818ed6be0";
      sha256 = "sha256-8fna2VbbUw8zBx77osaOOHlZFgRrHqwQK87RoUtCF6w=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.16.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=3e4817538de828319ba6d59ced2fbb9b5ca13287";
      sha256 = "sha256-iCZAyRS/a15x5aJCJBYl9nw6Hc3WRCUG7zF5V+OwDKg=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.17.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=f407e34f3871a4c402bbd516e7c28ea193cef1b7";
      sha256 = "sha256-S45cLZNTWapAodKudUz2fMjnPsW6vbtNz0bIvIBGmu4=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.18.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c1b7eef9fa4aaefbf7d0507505c3bb2914e1ad6b";
      sha256 = "sha256-TWPfEAOePwC77yiVdsTSZIjfsMp7+0XabCz9K3FlV7w=";
    })
    ## Needed to apply patch 19
    (fetchpatch {
      name = "net-remove-trailing-whitespaces.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=e453a4a64392a41bc7b37f890aceb358112d1687";
      sha256 = "sha256-JCbUB77Y6js5u99uJ9StDxNjjahNy4nO3crK8/GvmPY=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.19.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=96abf4fb9d829f4a405d5df39bc74bbccbd0e322";
      sha256 = "sha256-6E2MKO5kauFA1TA8YkUgIUusniwHS2Sr44A/a7ZqDCo=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.20.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ee9652031491326736714a988fbbaeab8ef9255c";
      sha256 = "sha256-E21q+Mj+JBQlUW0pe4zbaoL3ErXmCanyizwAsRYYZHk=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.21.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=8f287c3e13da2bf82049e2e464eca7ca4fef0a85";
      sha256 = "sha256-dZ24RwYsHeUrMuiU7PDgPcw+iK9cOd6q+E0xWXbtTkE=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.22.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=dad94fffe14be476df5f34a8e5a90ea62a41fe12";
      sha256 = "sha256-06TyTEvSy19dsnXZZoKBGx7ymJVWogr0NorzLflEwY4=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.23.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ec6bfd3237394c1c7dbf2fd73417173318d22f4b";
      sha256 = "sha256-NryxSekO8oSxsnv5G9mFZExm4Pwfc778mslyUDuDhlM=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.24.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=b26b4c08e7119281ff30d0fb4a6169bd2afa8fe4";
      sha256 = "sha256-fSH3cxl/76DwkE8dHSR9uao9Vf1sJrhz7SmUSgDNodI=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.25.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=4bd9877f62166b7e369773ab92fe24a39f6515f8";
      sha256 = "sha256-VMtR/sF8F1BMKmJ06ZZEPNH/+l0RySy/E6lVWdCyFKE=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.26.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=deae293f399dde3773cf37dfa9b77ca7e04ef772";
      sha256 = "sha256-sCC3KE9adavw7jHMTVlxtyuwDFCPRDqT24H3AKUYf68=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.27.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=e40b83335bb33d9a2d1c06cc269875b3b3d6c539";
      sha256 = "sha256-cviCfBkzacAtnHGW87RLshhduE4Ym/v2Vq4h/sZDmZg=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.28.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=11e1cffb7e2492ddac4ab8d19ce466783adbb957";
      sha256 = "sha256-I1feoneVeU3XkscKfVprWWJfLUnrc5oauMXYDyDxo5M=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.29.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=13dce204cf6f3f0f49c9949971052a4c9657c0c0";
      sha256 = "sha256-DzFHxgR9A8FNZ/y9OMeBvTp1K6J5ePyL06dhHQmk7Ik=";
    })
    (fetchpatch {
      name = "CVE-2021-3695.CVE-2021-3696.CVE-2021-3697.CVE-2022-28733.CVE-2022-28734.CVE-2022-28735.CVE-2022-28736.CVE-2022-28737.30.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=2f4430cc0a44fd8c8aa7aee5c51887667ad3d6c3";
      sha256 = "sha256-AufP/10/auO4NMjYQ7yPDDbYShwGaktyQtqJx2Jasz8=";
    })
    # October 2022 security patches
    # https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.1.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=f6b6236077f059e64ee315f2d7acb8fa4eda87c5";
      sha256 = "sha256-pk02iVf/u6CdsVjl8HaFBh0Bt473ZQzz5zBp9SoBLtE=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.2.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=9c76ec09ae08155df27cd237eaea150b4f02f532";
      sha256 = "sha256-axbEOH5WFkUroGna2XY1f2kq7+B1Cs6LiubIA2EBdiM=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.3.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=768e1ef2fc159f6e14e7246e4be09363708ac39e";
      sha256 = "sha256-aKDUVS/Yx1c87NCrt4EG8BlSpkHijUyAJIwbmtzNjD8=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.4.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c51292274ded3259eb04c2f1c8d253ffbdb5216a";
      sha256 = "sha256-OLNOKuAJuHy2MBMnU2xcYM7AaxmDk9fchXhggoDrxJU=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.5.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=23843fe8947e4da955a05ad3d1858725bfcb56c8";
      sha256 = "sha256-ptn00nqVJlEb1c6HhoMy9nrBuctH077LM4yXKsK47gc=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.6.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=b9396daf1c2e3cdc0a1e69b056852e0769fb24de";
      sha256 = "sha256-K7XNneDZjLpZh/C908+5uYsB/0oIdgQqmk0yJrdQLG4=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.7.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1d2015598cc7a9fca4b39186273e3519a88e80c7";
      sha256 = "sha256-s4pZtszH4b/0u85rpzVapZmNQdYEq/wW06SQ3PW/1aU=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.8.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=93a786a00163e50c29f0394df198518617e1c9a5";
      sha256 = "sha256-R8x557RMAxJ0ZV2jb6zDmwOPVlk6875q37fNpqKsPT0=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.9.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1eac01c147b4d85d2ec4a7e5671fa4345f2e8549";
      sha256 = "sha256-eOnhmU3pT5cCVnNHcY/BzDjldfs7yh/OGsxa15tGv94=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.10.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=992c06191babc1e109caf40d6a07ec6fdef427af";
      sha256 = "sha256-kezNKPcLmFXwyZbXtJbaPTIbE8tijmHIzdC2jsKwrNk=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.11.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=9d81f71c6b8f55cf20cd56f5fe29c759df9b48cc";
      sha256 = "sha256-jnniVGy4KvFGFmcOP2YLA46k3cK8vwoByo19ismVUzE=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.12.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=22b77b87e10a3a6c9bb9885415bc9a9c678378e6";
      sha256 = "sha256-iYTEqN5997I7MVIg82jt/bbEAYhcgq8fNRCNPpY9ze0=";
    })
    (fetchpatch {
      name = "CVE-2022-2601.CVE-2022-3775.13.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1514678888595ef41a968a0c69b7ff769edd1e9c";
      sha256 = "sha256-tgAEoAtaNKJjscjMFkXXiVn59Pa4c+NiQ3iVW6CMrpo=";
    })
  ];

  postPatch = if kbdcompSupport then ''
    sed -i util/grub-kbdcomp.in -e 's@\bckbcomp\b@${ckbcomp}/bin/ckbcomp@'
  '' else ''
    echo '#! ${runtimeShell}' > util/grub-kbdcomp.in
    echo 'echo "Compile grub2 with { kbdcompSupport = true; } to enable support for this command."' >> util/grub-kbdcomp.in
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison flex python3 pkg-config gettext freetype autoreconfHook ];
  buildInputs = [ ncurses libusb-compat-0_1 freetype lvm2 fuse libtool bash ]
    ++ lib.optional doCheck qemu
    ++ lib.optional zfsSupport zfs;

  strictDeps = true;

  hardeningDisable = [ "all" ];

  separateDebugInfo = !xenSupport;

  # Work around a bug in the generated flex lexer (upstream flex bug?)
  NIX_CFLAGS_COMPILE = "-Wno-error";

  preConfigure =
    '' for i in "tests/util/"*.in
       do
         sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
       done

       # Apparently, the QEMU executable is no longer called
       # `qemu-system-i386', even on i386.
       #
       # In addition, use `-nodefaults' to avoid errors like:
       #
       #  chardev: opening backend "stdio" failed
       #  qemu: could not open serial device 'stdio': Invalid argument
       #
       # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
       sed -i "tests/util/grub-shell.in" \
           -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'

      unset CPP # setting CPP intereferes with dependency calculation

      patchShebangs .

      substituteInPlace ./configure --replace '/usr/share/fonts/unifont' '${unifont}/share/fonts'
    '';

  configureFlags = [
    "--enable-grub-mount" # dep of os-prober
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # grub doesn't do cross-compilation as usual and tries to use unprefixed
    # tools to target the host. Provide toolchain information explicitly for
    # cross builds.
    #
    # Ref: # https://github.com/buildroot/buildroot/blob/master/boot/grub2/grub2.mk#L108
    "TARGET_CC=${stdenv.cc.targetPrefix}cc"
    "TARGET_NM=${stdenv.cc.targetPrefix}nm"
    "TARGET_OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "TARGET_RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "TARGET_STRIP=${stdenv.cc.targetPrefix}strip"
  ] ++ lib.optional zfsSupport "--enable-libzfs"
    ++ lib.optionals efiSupport [ "--with-platform=efi" "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}" "--program-prefix=" ]
    ++ lib.optionals xenSupport [ "--with-platform=xen" "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}"];

  # save target that grub is compiled for
  grubTarget = if efiSupport
               then "${efiSystemsInstall.${stdenv.hostPlatform.system}.target}-efi"
               else if inPCSystems
                    then "${pcSystems.${stdenv.hostPlatform.system}.target}-pc"
                    else "";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    # Avoid a runtime reference to gcc
    sed -i $out/lib/grub/*/modinfo.sh -e "/grub_target_cppflags=/ s|'.*'|' '|"
    # just adding bash to buildInputs wasn't enough to fix the shebang
    substituteInPlace $out/lib/grub/*/modinfo.sh \
      --replace ${buildPackages.bash} "/usr/bin/bash"
  '';

  passthru.tests = {
    nixos-grub = nixosTests.grub;
    nixos-install-simple = nixosTests.installer.simple;
    nixos-install-grub1 = nixosTests.installer.grub1;
    nixos-install-grub-uefi = nixosTests.installer.simpleUefiGrub;
    nixos-install-grub-uefi-spec = nixosTests.installer.simpleUefiGrubSpecialisation;
  };

  meta = with lib; {
    description = "GNU GRUB, the Grand Unified Boot Loader (2.x beta)";

    longDescription =
      '' GNU GRUB is a Multiboot boot loader. It was derived from GRUB, GRand
         Unified Bootloader, which was originally designed and implemented by
         Erich Stefan Boleyn.

         Briefly, the boot loader is the first software program that runs when a
         computer starts.  It is responsible for loading and transferring
         control to the operating system kernel software (such as the Hurd or
         the Linux).  The kernel, in turn, initializes the rest of the
         operating system (e.g., GNU).
      '';

    homepage = "https://www.gnu.org/software/grub/";

    license = licenses.gpl3Plus;

    platforms = platforms.gnu ++ platforms.linux;

    maintainers = [ maintainers.samueldr ];
  };
})
