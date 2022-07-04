{ fetchFromGitLab
, fprintd
, libfprint-tod
}:

fprintd.override { libfprint = libfprint-tod; }
