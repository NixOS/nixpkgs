{
  mkKdeDerivation,
  fetchFromGitLab,
  sources,
  shared-mime-info,
}:
mkKdeDerivation rec {
  pname = "bluedevil";

  # Upstream tarball is broken, so fetch from Invent temporarily.
  # FIXME: remove in next release.
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "bluedevil";
    rev = "v${sources.${pname}.version}";
    hash = "sha256-3scHXPZ6dSWa2yea89R1u4jbkr6IFP6jvTLEC4O5uYY=";
  };

  extraNativeBuildInputs = [shared-mime-info];
}
