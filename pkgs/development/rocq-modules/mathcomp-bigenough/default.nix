{
  rocq-core,
  mkRocqDerivation,
  mathcomp-boot,
  lib,
  version ? null,
}:

let
  derivation = mkRocqDerivation {

    namePrefix = [
      "rocq"
      "mathcomp"
    ];
    pname = "bigenough";
    owner = "math-comp";

    release = {
      "1.0.0".hash = "sha256:10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg";
      "1.0.1".hash = "sha256:02f4dv4rz72liciwxb2k7acwx6lgqz4381mqyq5854p3nbyn06aw";
      "1.0.2".hash = "sha256-fJ/5xr91VtvpIoaFwb3PlnKl6UHG6GEeBRVGZrVLMU0=";
      "1.0.3".hash = "sha256-9ObUoaavnninL72r5iqkLz7lJBpcKXXi8LXKGhgx/N4=";
      "1.0.4".sha256 = "sha256-cwfDCEFSXWnqV5aIrhTviUti0CXNwmFe6zVbqlD2iZw=";
    };
    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch rocq-core.rocq-version [
        (case (range "9.0" "9.3") "1.0.4")
        (case (range "8.10" "9.1") "1.0.3")
        (case (range "8.10" "9.1") "1.0.2")
        (case (range "8.5" "8.14") "1.0.0")
      ] null;

    propagatedBuildInputs = [ mathcomp-boot ];

    useCoqifVersion = v: v != null && v != "dev" && lib.versions.isLe "1.0.3" v;

    meta = {
      description = "Small library to do epsilon - N reasonning";
      license = lib.licenses.cecill-b;
    };
  };
in
derivation
