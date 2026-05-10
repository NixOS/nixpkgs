{
  version = "4.6.2-stable";
  hash = "sha256-alAW8i7wRcOsHvq3flYXgW7DPiIlAXxM1zFL87Kri6Y=";
  default = {
    exportTemplatesHash = "sha256-lCNm3E4n52hqmdpNPPsbiujT65RE9tghfu8WJFtZnvI=";
  };
  mono = {
    exportTemplatesHash = "sha256-Ts9y+vdvluAQ0Wbdu+Pw+459+WMygmZqOpr9TuPgDn0=";
    nugetDeps = ./deps.json;
  };
}
