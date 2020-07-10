{ lib, callPackage, fetchpatch, fetchurl, stdenv }:

let

generic = args:
if ((!lib.versionOlder args.version "391")
    && stdenv.hostPlatform.system != "x86_64-linux") then null
  else callPackage (import ./generic.nix args) { };
  kernel = callPackage # a hacky way of extracting parameters from callPackage
    ({ kernel, libsOnly ? false }: if libsOnly then { } else kernel) { };

  maybePatch_drm_legacy =
    lib.optional (lib.versionOlder "4.14" (kernel.version or "0"))
      (fetchurl {
        url = "https://raw.githubusercontent.com/MilhouseVH/LibreELEC.tv/b5d2d6a1"
            + "/packages/x11/driver/xf86-video-nvidia-legacy/patches/"
            + "xf86-video-nvidia-legacy-0010-kernel-4.14.patch";
        sha256 = "18clfpw03g8dxm61bmdkmccyaxir3gnq451z6xqa2ilm3j820aa5";
      });
in
rec {
  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "x86_64-linux"
    then generic {
      version = "440.100";
      sha256_64bit = "07ygp8xs293glbybv2psi5ykfdlpgwp03bkczf51fyzknkx895k4";
      settingsSha256 = "1chis62wk4a93m49w4ncq0za4h7si6f3ckbl9ifxx7vnab8rk6ly";
      persistencedSha256 = "142fdxhznzjsnmvgpmi9x7gy6mp3n25acxfnfmf37ncs4sk0wm6i";
    }
    else legacy_390;

  # No active beta right now
  beta = generic {
    version = "450.51";
    sha256_64bit = "17pam9737jx9vvczma5rafa0rihprccmfz84clb1y4nhbay5alf2";
    settingsSha256 = "09hc1mjh7s94hy37rslxrxr30kx9a4yfnkmv35wn86b2p9zk3w6n";
    persistencedSha256 = "0jmri8kj6gffqn8pm8nijhq2airvgid11vj2ffc037l7z4w0s6ar";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.138";
    sha256_32bit = "0y3qjygl0kfz9qs0rp9scn1k3l8ym9dib7wpkyh5gs4klcip7xkv";
    sha256_64bit = "0rnnb5l4i8s76vlg6yvlrxhm2x9wdqw7k5hgf4fyaa3cr3k1kysz";
    settingsSha256 = "0ad6hwl56nvbdv9g85lw7ywadqvc2gaq9x6d2vjcia9kg4vrmfqx";
    persistencedSha256 = "15jciyq6i3pz1g67xzqlwmc62v3xswzhjcqmfcdndvlvhcibsimr";
  };

  legacy_340 = generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

    patches = [ ./vm_operations_struct-fault.patch ];
  };

  legacy_304 = generic {
    version = "304.137";
    sha256_32bit = "1y34c2gvmmacxk2c72d4hsysszncgfndc4s1nzldy2q9qagkg66a";
    sha256_64bit = "1qp3jv6279k83k3z96p6vg3dd35y9bhmlyyyrkii7sib7bdmc7zb";
    settingsSha256 = "129f0j0hxzjd7g67qwxn463rxp295fsq8lycwm6272qykmab46cj";
    persistencedSha256 = null;
    useGLVND = false;
    useProfiles = false;
    settings32Bit = true;

    prePatch = let
      debPatches = fetchurl {
        url = "mirror://debian/pool/non-free/n/nvidia-graphics-drivers-legacy-304xx/"
            + "nvidia-graphics-drivers-legacy-304xx_304.137-5.debian.tar.xz";
        sha256 = "0n8512mfcnvklfbg8gv4lzbkm3z6nncwj6ix2b8ngdkmc04f3b6l";
      };
      prefix = "debian/module/debian/patches";
      applyPatches = pnames: if pnames == [] then null else
        ''
          tar xf '${debPatches}'
          sed 's|^\([+-]\{3\} [ab]\)/|\1/kernel/|' -i ${prefix}/*.patch
          patches="$patches ${lib.concatMapStringsSep " " (pname: "${prefix}/${pname}.patch") pnames}"
        '';
    in applyPatches [ "fix-typos" ];
    patches = maybePatch_drm_legacy;
    broken = stdenv.lib.versionAtLeast kernel.version "4.18";
  };
}
