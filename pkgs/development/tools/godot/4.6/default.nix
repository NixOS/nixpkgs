{
  version = "4.6-stable";
  hash = "sha256-lK9KQsmrNZLx7yP3PwbN93otwkWq2H+nWt85WH/u8oI=";
  default = {
    exportTemplatesHash = "sha256-OzCsjBdy8l9d+l9lkiyrCpDnuWAXaJEjfFdyUV68zEY=";
  };
  mono = {
    exportTemplatesHash = "sha256-RgVug5TNHx+FzPqr3f/Bpn9ZW/2Z+9ps1ir6dR2/xRk=";
    nugetDeps = ./deps.json;
  };
}
