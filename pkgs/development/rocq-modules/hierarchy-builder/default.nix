{
  lib,
  mkRocqDerivation,
  rocq-core,
  rocq-elpi,
  version ? null,
}:

let
  hb = mkRocqDerivation {
    pname = "hierarchy-builder";
    owner = "math-comp";
    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch rocq-core.rocq-version [
        (case (range "9.0" "9.3") "1.10.3")
        (case (range "9.0" "9.1") "1.10.2")
        (case (range "9.0" "9.1") "1.10.0")
        (case (range "8.20" "9.1") "1.9.1")
        (case (range "8.19" "8.20") "1.8.0")
        (case (range "8.18" "8.20") "1.7.1")
        (case (range "8.16" "8.18") "1.6.0")
        (case (range "8.15" "8.18") "1.5.0")
        (case (range "8.15" "8.17") "1.4.0")
        (case (range "8.13" "8.14") "1.2.0")
        (case (range "8.12" "8.13") "1.1.0")
        (case (isEq "8.11") "0.10.0")
      ] null;
    release."1.10.3".hash = "sha256-y13KxzLulIu39Ci3aMc1cZG4tw3LL2ab7U9snI6jrXc=";
    release."1.10.2".sha256 = "sha256-Uzni9qrYQP45Tr+JkHs0BuRARwmWSMwA/iHhIzkolxc=";
    release."1.10.0".sha256 = "sha256-c52nS8I0tia7Q8lZTFJyHVPVabW9xv55m7w6B7y3+e8=";
    release."1.9.1".sha256 = "sha256-AiS0ezMyfIYlXnuNsVLz1GlKQZzJX+ilkrKkbo0GrF0=";
    release."1.8.0".hash = "sha256-4s/4ZZKj5tiTtSHGIM8Op/Pak4Vp52WVOpd4l9m19fY=";
    release."1.7.1".hash = "sha256-MCmOzMh/SBTFAoPbbIQ7aqd3hMcSMpAKpiZI7dbRaGs=";
    release."1.7.0".hash = "sha256-WqSeuJhmqicJgXw/xGjGvbRzfyOK7rmkVRb6tPDTAZg=";
    release."1.6.0".hash = "sha256-E8s20veOuK96knVQ7rEDSt8VmbtYfPgItD0dTY/mckg=";
    release."1.5.0".hash = "sha256-Lia3o156Pbe8rDHOA1IniGYsG5/qzZkzDKdHecfmS+c=";
    release."1.4.0".hash = "sha256-tOed9UU3kMw6KWHJ5LVLUFEmzHx1ImutXQvZ0ldW9rw=";
    release."1.3.0".hash = "sha256:17k7rlxdx43qda6i1yafpgc64na8br285cb0mbxy5wryafcdrkrc";
    release."1.2.1".hash = "sha256-pQYZJ34YzvdlRSGLwsrYgPdz3p/l5f+KhJjkYT08Mj0=";
    release."1.2.0".hash = "sha256:0sk01rvvk652d86aibc8rik2m8iz7jn6mw9hh6xkbxlsvh50719d";
    release."1.1.0".hash = "sha256-spno5ty4kU4WWiOfzoqbXF8lWlNSlySWcRReR3zE/4Q=";
    release."1.0.0".hash = "sha256:0yykygs0z6fby6vkiaiv3azy1i9yx4rqg8xdlgkwnf2284hffzpp";
    release."0.10.0".hash = "sha256:1a3vry9nzavrlrdlq3cys3f8kpq3bz447q8c4c7lh2qal61wb32h";
    releaseRev = v: "v${v}";

    propagatedBuildInputs = [ rocq-elpi ];

    useCoqifVersion = v: v != null && v != "dev" && lib.versions.isLe "1.9.1" v;

    meta = {
      description = "High level commands to declare a hierarchy based on packed classes";
      maintainers = with lib.maintainers; [
        cohencyril
        siraben
      ];
      license = lib.licenses.mit;
    };
  };
  hb2 = hb.overrideAttrs (
    o:
    lib.optionalAttrs (lib.versions.isGe "1.2.0" o.version || o.version == "dev") {
      buildPhase = "make build";
    }
    // (
      if lib.versions.range "1.1.0" "1.9.1" o.version then
        { installFlags = [ "DESTDIR=$(out)" ] ++ o.installFlags; }
      else if lib.versions.range "0.10.0" "1.1.0" o.version then
        { installFlags = [ "VFILES=structures.v" ] ++ o.installFlags; }
      else
        { }
    )
  );
in
hb2
