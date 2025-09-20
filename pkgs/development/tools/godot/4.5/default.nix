{
  version = "4.5-stable";
  hash = "sha256-ENDgZBM/bgL+Wlvy6GhE8a5Lyj44OqH7nOF3y74Bf/8=";
  default = {
    exportTemplatesHash = "sha256-N12DtmF5T5F0bS3sm1aamdTST4WnDE7ABoqvsYtVHVM=";
  };
  mono = {
    exportTemplatesHash = "sha256-rRGCBdiuMEurhPqTdZC9G0OpVnu3+CvneGeMiRzoWLs=";
    nugetDeps = ./deps.json;
  };
}
