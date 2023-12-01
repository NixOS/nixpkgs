{ lib
, buildPythonPackage
, pythonOlder
, aiobotocore
, botocore
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.6.0" "sha256-Bit55lGYI8+VOEm+6NKlfxWldFWdiAFwRZjJsgwuv7Q=";

  types-aiobotocore-account = buildTypesAiobotocorePackage "account" "2.5.2.post3" "sha256-zuBKsuPD3Sjl8KWKIlMgKtzfmtVc8ZZyIMKyPC2QjmY=";

  types-aiobotocore-acm = buildTypesAiobotocorePackage "acm" "2.5.4" "sha256-B7SsW+FtSOMfFFdfmH9iv/i9R/qj6ImAr95gpPAf3G4=";

  types-aiobotocore-acm-pca = buildTypesAiobotocorePackage "acm-pca" "2.6.0" "sha256-AO3CEqWkLBTkx4k8YamcUUCg2TwHODCMjz6ujubzLjA=";

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.6.0" "sha256-Pjfm+q8Wq7BT3QfFcLuODteOZdvNXSegde1sc6z2UOk=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.6.0" "sha256-EZ/wSfcWnT7DoSRegMZnzukVLlTFYP2UsR+rEiLwtnE=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.6.0" "sha256-IkvRE9xD0y8l48rWuV1cvnOQ7eHr0hYsrD3NusofgyI=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.6.0" "sha256-4sSNDhmNuOnYPq0X/G8m0XDP08W+MUQ3xiWK9Yc8U6Q=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.6.0" "sha256-K1esoNUDYWzqK12X6o5c12XJQGGDNlCyUiVsNsUaQhI=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.6.0" "sha256-r4eDPDqkcQhApN/+4xjDuillQnDOqu2xqyACYHqXRpw=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.6.0" "sha256-sAJW4q/mUaRsiN7Yt/uBMbxDfKhTSdiZaDd7nvvM3og=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.6.0" "sha256-cNNVvAX1o+ZieUaW59yp5ELFf2S96XdCOLeVe91oFI8=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.6.0" "sha256-qliKZTlmnPwRdhQs26M0PlCM91Mn7cHCmccCAhDtryU=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.6.0" "sha256-DcLOpKbUl/YOinXXtlo2su0uMh0Ja5cGrpbmKuQVGvw=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.6.0" "sha256-yQvNa3iBsoAD4oBVmt0ZNjziBEhzTUE6E6FFLluxTZw=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.6.0" "sha256-ILdWiqipfSnSjdToIq++JIu1WUmv+lMX72Ymo9KGZ9s=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.6.0" "sha256-ZPNB2PUpeTttagX1rRmgINgahj3cNuBdKQMvdFNK15Y=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.6.0" "sha256-p5EgvysfhIHz4ZALV8tJz/7ZkRIu2BIZwENiiVho67w=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.6.0" "sha256-PUDqMFJu2BG3WVCS6SYyltrSr64VblVAgrCYQ6FR2sk=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.6.0" "sha256-bGlbP0d38vFHkITC84N43Vt1Nrsf3+ByWSvvteDejBw=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.6.0" "sha256-Lcoc/IJ9o1glV8gNNA/t9B3J6K5Qz/50fqPMsF78WVI=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.6.0" "sha256-zyesnbNmSrQEsBVQJouP05zxhBTikGZVCR/VFdEkHNE=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.6.0" "sha256-+4LWBHHwL1R4jBGHChSUOq9vFc+k7NmRXvo8ZjDIyXk=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.6.0" "sha256-JFrBy9Ck/Ni4lwHV47fkzt/YI5cX9FvTeaT0tNgzdqs=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.6.0" "sha256-qTW58yyFwbBYyisuL4NkaEXqblJ3vevXI1lHZVX4mZY=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.6.0" "sha256-xmTKI8q82UohBE+Wh+j1xivsY8wmrcvOlDAlwTpJmxE=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.6.0" "sha256-a+47CFM19RM3Y+9wLLe8D4II7rKeDQ93dy68jqJqBD4=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.6.0" "sha256-s0ClcRgYJcd5GZXYWMn2FieNXebdlS9206mLtKCSy44=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.6.0" "sha256-ZhOokFIm5KHBc5X+Lp19z5N7BudTQHU5KjHGYCrW/aE=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.6.0" "sha256-rmm10kZXRkmj0TxqARf+57Nz8LapZF7TaH9GGwhIHys=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.6.0" "sha256-/YH0nuyWaEVPlZFxJarGkWOnLcpiIvvf/GCmxMOaybI=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.6.0" "sha256-OC1xWUT0BjBoelAxHkprhD54kF+YbK30H/42Q3XxdwY=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.6.0" "sha256-/5yrgR7NbQ6GbkC9SsHaAhDa3juBjyRt705wHTu6Mr8=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.6.0" "sha256-bDEICyyIUCRxbTWZFXHsj5yncQI+F+geC92vvsrKCxw=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.6.0" "sha256-aobQZov192xNkN7cwIKLgJnhxltyLpWw1oKk2m1HkV8=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.6.0" "sha256-0tFKq0VomVAD9NRtlQzilQEZHFOZp40vtTKfoBqjpyU=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.6.0" "sha256-eKYNFMlDt9uUaqsK8PPTpt1wghN3nGgM+idQBVei8eY=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.6.0" "sha256-5d9LUaSDvYI/Nrsmg4MnM0ucXmyzUQKV4DpX9pZst2s=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.6.0" "sha256-UXVS4iTbkv9/xmL5AFv3xlWtWk5qN/dam/ic4mg3+cI=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.6.0" "sha256-+2AioI5B/K5QhDsaBSAFyNW0Fd49EA8ZBVrULd3u7qQ=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.6.0" "sha256-oxlFkYpDoi7pidqzDOYdeTazVl/HjnuZmnjMGZa/WIE=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.6.0" "sha256-THOQl3ZUILwLRwYlBb7fQDgpYz7wkMyd+tSLEmHHBVY=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.6.0" "sha256-RwMXK2NrM4BDzeg5lcpxfVzxFzrqjZw+xhZnJL81Uqw=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.6.0" "sha256-i2XmS1m6YO7dOaMZKb0WRQB2WpRue+OCLbdR59oWA1Q=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.6.0" "sha256-W3ni8q7n4l8+SP/RyxibCTptextx4Vd8bmiQ3lhgszQ=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.6.0" "sha256-qWbYfegOQ6QcEWA/gce9ZiIOBIVeWIj1qjfsksncDxY=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.6.0" "sha256-5TzDHj/t0tqxbRYfnGRP9LNq9pSFj7aidadVB03ZY1k=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.6.0" "sha256-EyiQY0NCVa3XuRpBH7aXEA7cBx8BzyRP917f/Ogx0mw=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.6.0" "sha256-f9nqoXlg7sgY2QCkE1/+Q72N/8Besrl6gncmU+vNt/I=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.6.0" "sha256-a3QRjQhW+cRJykNjhhJREGwuZxR0b+WxgRuS2yuGcTQ=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.6.0" "sha256-FyktFlTQAbS6YnoXljvtn6CabJHGLkRv1jCgb9dbz+s=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.6.0" "sha256-eKLM+GYjbm3cweMtF/XI6k+P8t9gaJeRCeMHQbc832g=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.6.0" "sha256-wn03HlgBaZIAkw8gxPehSKpcfQGOhYp0U1CF/84M/lg=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.6.0" "sha256-/vpOE8tU7SsjHmn/YyVfku05ZGBZIiVuFsG6aK47K28=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.6.0" "sha256-8W7TrB1EXp5JeBQ9xqkqFhf+Frflpd5bfVxpqju2ZPM=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.6.0" "sha256-ntQkDjM3I3wuMH5jsifODEwRna2ctRW1M9bzyEjIF7w=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.6.0" "sha256-NuMqaomry4ezNNRKBLOJ0xNwGUO2Prl4nf/5O38oyqI=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.6.0" "sha256-dYe3uLk0ssQPQPEo+3glh+ic6recgV5WPIN09lLuuA4=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.6.0" "sha256-7MKRVJ4fgberRmkHWHfvrfzU2+BYhMZxgb2ge7NAQp4=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.6.0" "sha256-7StmPVxVNfFpqQmjyM4cn9NBrAsuUjxRkP0WgGCnuso=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.6.0" "sha256-4TUcqf3kuRqsMjhfrUTX3/aOSl43NtwmbSgM6KtjAlk=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.6.0" "sha256-qD42WySh9NpQBOveTRGP3hIp8zD1Y1DzSiM7kbbfR88=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.6.0" "sha256-1qgsFoogu8MnWoCeKnqy4KIY7UdMeUPnaS1zVSVl2Mg=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.6.0" "sha256-7Nbb+l7y5ccrVGymZ46nKwnGoa5nThrIOZ1AG0ykPEw=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.6.0" "sha256-cIvM4g/CldgLuN10a3lNhISz08gT6VxZHMS5xo+B2IA=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.6.0" "sha256-6b3QfRecmprhRU+loWafrcL1mWNLFmZXZOAhUMkpGqU=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.6.0" "sha256-D/icEGVsuYSU7hCw2VEojLTkdaBcK6SoEZqpvD/NKV0=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.6.0" "sha256-7vWHwrG7Z80Zb3ncGBqN4ItKAVWLR0XHITJxMmE8y8Y=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.6.0" "sha256-C1JRefgyuiKDOJMhShyDPDjfKp5S5OMCaHcnORLxnvY=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.6.0" "sha256-ks8MmuhrmdTS509vgxZ0raZqISMPaAItEjf93ppWhrU=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.6.0" "sha256-pOLa8tDqPexDigPbRqTjnr7/ricz92/Ml79AyUXvXBg=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.6.0" "sha256-qXIwjiNksQbQiTtwaKWNHaUCras/moRuFXN3sOEPYMc=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.6.0" "sha256-C98s7dkFRgj8m4M+MmjvCWwrdohkLJafgo9j2ACQ2l4=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.6.0" "sha256-4MRGtyFWceAuspTW6Xqwjf2ta0VC1SIoK/U80QZw7UA=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.6.0" "sha256-qW+R5X/fu784kjARjISaNxwzIJn74SXfUaPEuGqsM1M=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.6.0" "sha256-d+7VqW5H0hyINQVXoy6djyFmkGzlhLnEpzURuPQLyBc=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.6.0" "sha256-3d2WJQpohaiwdsKOS2u5kNhHVsgELMxgjunHAk6v7Y8=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.6.0" "sha256-lsDs0yxFf4ForZ2bU719LFCDHzR9lOE211XuYGYKZCw=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.6.0" "sha256-/MRl46K5h5mtboGhWDop0psxPyxhm3tKhzvMpr91d/w=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.6.0" "sha256-3E+8scTPCcNm8RDoxGWSm/u6drT12aiFqf3LbxWTy8w=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.6.0" "sha256-Df25Lah8FBdCrbWMC+Y9ayQCO3ijG8cMdypA2+sE3oY=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.6.0" "sha256-i+n53Eejdz26WGsHBmLR3V0ZxOBHPtTTzoxH0mmKPig=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.6.0" "sha256-i1mv2M3bboOF3+iIKYhp4raYb7mHiQTirlWsttB/dXY=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.6.0" "sha256-WMVPGbQkdbKc2T+gR9P3oWUxl5VSVf4IdcLeuW9SNUo=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.6.0" "sha256-okcgm0Lx5s2AM2mprVwNjeI1TTmlR73FgjWbYa9uRdE=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.6.0" "sha256-k0tYIWqPEnETISThasPHa9AaWdAs0p+hfrUuCI7VTJk=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.6.0" "sha256-C138viPl57+Z79k1C0c4IjgdpMd4PhO352fUs6/YnE0=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.6.0" "sha256-1BtV4vajDTlmNhX4oh1h81+1MsIe63gxnkd1oWn0yeI=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.6.0" "sha256-UP8rTuCwNq6Eu5gYrMj5c+JaNy9grOOL9RRi/QsDvzE=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.6.0" "sha256-Mc4Kl4dZyn9y+9V44QilacOHN9+E1M79uNLATsoH2Ks=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.6.0" "sha256-pPn7O3oK75zRmOFMQmyzmRcjpRTswrVhdbkcqaI5Sj8=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.6.0" "sha256-LwbqLf3BEwW/+f6vsddXt+FiyGkRKIPXfaqW5rtDrig=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.6.0" "sha256-mBruXgMAELLGyEg7ON8PFesERMf5og8As58U9pvIKRc=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.6.0" "sha256-JLOVu9OlJgrfTBlmzVNN5saYO8AFk8N54hRzDAjq7WI=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.6.0" "sha256-cWGwdGBTgEag5SeRDLvAJtCS1dAxtt5R0uanPI6RjkY=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.6.0" "sha256-yYm/H31gRIDV+r2H+8cTHkc5h40aFFUQ7zlX1wyLPAI=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.6.0" "sha256-ro0xv2HHzTXA6tRNnr3eQjCj5iaqc1wOcsKny8j/hoQ=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.6.0" "sha256-4CeNeftLpPSZYqw09LcPRC+8yVp+84azRHQ8O0JFOOo=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.6.0" "sha256-HZEA8fivN05Puxycyl+2z4kIJMbGtF0J7ohLOwx+IzM=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.6.0" "sha256-dFo/YsEQg7TXB5NENmFOv37R3B2GoN0TlIiULWEQr9I=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.6.0" "sha256-8wsE774l7M8Qb3UiaxkAdN6sdnXs5oS4cFhncW0joBI=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.6.0" "sha256-95lUlfOjLVgHufSv3UvaKB1K0F2N0cvtCcKh96VBtqg=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.6.0" "sha256-hSuwPcQEk9Qgkc/JtcZp2vqLXnMQN9gtzjkuC1Bv1C4=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.6.0" "sha256-0Lwxob43TzJHNcriUEa3BAZE64iqS9Js4TtfL20YRj0=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.6.0" "sha256-bMPp7QPa2f8GCRmX3y78XvZTUyYNfYxXDKj5lckBBvE=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.6.0" "sha256-O2RieTv4vyZ6/mR8BRltfbGcPUjAyIIqriskSlmNcb4=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.6.0" "sha256-C660Ync/6dV8c9i+N7bgV0TYaPScrJ40KPdG3LItGGs=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.6.0" "sha256-jhIpP0cJEv2SqvmBJtxNVoWF4AOWci2sPj04dN3N+bo=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.6.0" "sha256-MXMbA1QAyRMhTqihwKztK3EoRp1iesCvPEz30Xc/in8=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.6.0" "sha256-xjMVOk0fzyvDoSNb+kxVQT9emfvIG/6Ws3h3MfCCTOY=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.6.0" "sha256-7iUYuPOerdp1+fxI/KdC4sEWDOTJQAgYYheEmSvjBFo=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.6.0" "sha256-yCF9EHyTsf1hmoeSGrNiM2Dd8gtGlcX79zqF25btN04=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.6.0" "sha256-vRVH67/SbkncE4q3gssGce4NtTYgFM56RLzDKyvBCpc=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.6.0" "sha256-+mFIAOecS21QFsnB+V1EFyGLv6uW+oMzkRi051HvPGA=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.6.0" "sha256-OIWzkp7AC2bK55bl3WvL2Zk7M0WRPc8jVHekPAGDtyw=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.6.0" "sha256-TWCgT2xBi3UajaF6L+m61Q27YV8RCm+e/jRVnZKjwrI=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.6.0" "sha256-pBr9zVqEbP0na385scKW28d0qIB+7HQdYC5QTdhxHNA=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.6.0" "sha256-mdpuehCY0ki+sZSlNS0kIwijZphoyQixNWY4WKEcrMs=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.6.0" "sha256-lFbcxmw7Le/rVVL70cOY/vEUShSRnsOdul+eI1jzX7Y=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.6.0" "sha256-A/1kM0X4bKrPIXBpir9FuEkuYmUb/K06gfut6faGN0A=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.6.0" "sha256-X0r0VZ/ZWYrn2NdE5dJrcS74OyWIvWMDJGSNheIOm0A=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.6.0" "sha256-ec9XPmiGjhH+MsW81JtH13KACasiWqtmxOC/O8ewbgE=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.6.0" "sha256-fPG/13VJzvdfoADYZXTZ2ssdJrKQ/MEic6rhsNUE4tU=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.6.0" "sha256-2mAHrKw7Hur/nrVQpuRwGae5CumbjbQb4V9Z6NlsSmo=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.6.0" "sha256-viWUrt2F0O1jVhkxK5G776A4r7d4jJJVI/5UsUS+cao=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.6.0" "sha256-4T/EcdB+5TV8PnX1Z9c8Ato19kznO3yQPZohuWD1+J8=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.6.0" "sha256-VIGEXyDyUEWshdYFUJ3VmCS1z/ZBOKq2PYCosalPZAw=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.6.0" "sha256-rMjrKtR8BWtAYoyBY52o/5wbZCHqX1aFMRsVCunZTeo=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.6.0" "sha256-rh53/1tmYyADrkUtQjrwrcEe78ji6II0yYnMQO38AOU=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.6.0" "sha256-ICRkb+GIWginbc2LvsJTzBaEXDlwg+JOqWQwNRzu+CI=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.6.0" "sha256-vZiK+Kat3RKN/OcKny5qLF+pYljoVlJGG9Kdlb75GWk=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.6.0" "sha256-9qk0jvEAU6vh++k18ccjrZNLnYlOqiAGuVvBGS5QetQ=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.6.0" "sha256-9iV7bpGMnzz9TH+g1YpPjbKBSKY3rcL/OJvMOzwLC1M=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.6.0" "sha256-shUgv/KntAP0kuD8pJFLEAp/aIukEsLhte6C5odtNJs=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.6.0" "sha256-U/74XOX/pXh4JJ4n6Fu6quL6gQwz+zt9bOWj/QYOS+8=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.6.0" "sha256-K2asnioD1r9BJCX2PaNaN+fKDyA+oQhvdM0h0LgxbEY=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.6.0" "sha256-acNr8U/E2Eq4wp68Td0k8xdORhT6ZOJBOi0enBnaacE=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.6.0" "sha256-9mqnIWlLUoz28qp8AH8LiNdDgcJ04P0Z+jxNb/91jUg=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.6.0" "sha256-+G6nPOY2Suxa8LPTG8SHOZfwaIJQIyVGTRcsAQYXZzY=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.6.0" "sha256-VGGDcARvtSeukjgVB9jwSamIrlrNCF+0pNszN6VkMC0=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.6.0" "sha256-3bScTMTc7PMrHvZpfPYENj55w2JjnK/pVuNLcxCjw5Q=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.6.0" "sha256-WBxZlnWrZ6b0MIEomvgUDqiKNe9KIIgOrNrRhRw07EA=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.6.0" "sha256-8ofimJ4eTxq8yQjCc23FQ2OktMCNwlIBCn+eC+HLqlc=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.6.0" "sha256-dCjt22yHlShPdG6Jipy3m4Rx3G4OLPiuUi1gyubcQ/g=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.6.0" "sha256-NPvYTwvZY5MjfdIlTMRZEQ1S9IvxvQjoi5K2LOlSrMM=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.6.0" "sha256-u4d+/kVZ+qtLyueNSGy6a2VoB0jIYdKZqvCQQfarbx4=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.6.0" "sha256-uhkFIVr68n0ShrpZY9qyghd0XgMb0ZT6fF9WdjtF7g0=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.6.0" "sha256-m0fUuupB8Eb9pJQnuir4THb4TdDstKcxHQRgz8Ce2Zg=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.6.0" "sha256-dJQnb6AwtmScEIun0QB9CiiPkbdKti9+mc5LN3vf7e0=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.6.0" "sha256-kAhdyymMdbrPoCFzKiVCFzBlfpmz4aGlZ1Ilkrc8EiQ=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.6.0" "sha256-3oJbkuU013LR7DUXvr8y0nbYh3caAF1c4GtgM1CizdU=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.6.0" "sha256-Rt6dsE/9aR5AZC47G3RayV56VVobDWEah64cNHsaYII=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.6.0" "sha256-KpgEjoEsCSiC6aKyHy64it0k87XYICbxMhUFYUjCBuo=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.6.0" "sha256-IQRarMn1ZAh+kUG1I4Cyt/6WrIoby07g3qcSzpWUWWM=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.6.0" "sha256-BFSV0lfXriD43UFXjdomHIQO60TjrYWmL6+htf9Z3mE=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.6.0" "sha256-MRRil8KuR88NvjAOQHQSftplzk7+sdAJBb1Koxj1j8o=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.6.0" "sha256-6YRdsbNw685KvSLCPP6cpCVA5zqht9gF/SthHHtjxfI=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.6.0" "sha256-uhxX742flhdDM7zoYm6yggc41NW7glGPijiql4XKJa4=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.6.0" "sha256-jrOVxsJHgpEvyLhreMrzttu3yQ4FXm4+MVDlNNIKWVU=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.6.0" "sha256-M3wUbFFGsYQesy7ASen+b6yokGkjXY0P5wpGexO2CGg=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.6.0" "sha256-ESm7ZCtEvHo/r9LXnBaIAVAb4bQkGjIlmUNlo/JuzjE=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.6.0" "sha256-0NMp62HDGZ0FHVtyHOvgfMUaedqZG9bY46d2OrpGK7E=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.6.0" "sha256-jbLoJOgFRNSPaFv/diM8L0mTGIB2IjAzHqx/QH7lriQ=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.6.0" "sha256-8zvG95bDvJWNRmw9sCdBfPxQPdb4TNAzqMcth+hliLI=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.6.0" "sha256-1i4Z4CE9PG7JByR9RpPazu7RmPIjNeDecnz5LH2ls2A=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.6.0" "sha256-6161RDBwnvqvBtJWs5bPieI6AdwKFCmiT6ixKRE9GuM=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.6.0" "sha256-/h85AoG+poq4t0EvpXdofWfbaEBD6CiCxhdaGKLi4C0=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.6.0" "sha256-kuOboqDTHpdSW6vD/JGOdLL2U639wM+2V2KaSm1j0xo=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.6.0" "sha256-CiMKW2suhsU2dZsLQkL3hK2qKRJ56FS4Ix7Dt347bMA=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.6.0" "sha256-y4RRQdjaJS9GLW7HUNC9f3kWCOAGijlisrlB0MYQ1As=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.6.0" "sha256-5ANdk601wY6vtjYbe8CxtY9lK4Fe6wbl5uB6Mq6uqII=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.6.0" "sha256-cvmNob4pGa18W/2uh16zFJ58f0MHRDL2LwOKrsO16uI=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.6.0" "sha256-pOk51+FrlKDNPPDaa1mf3HjpCqlUskeRYITkFp91l6M=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.6.0" "sha256-1WeJI++z4QiF0bZ4FyNgoNWY6X62ZCyq7PGNM9urFn4=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.6.0" "sha256-uaeHdW8lew6jq2KQApkY76eWRkYVLffN0h71icP9viE=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.6.0" "sha256-vbWWkLbVnzfWHp3Yy3S6mh0+tHrkA/5Krw4GVSdILls=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.6.0" "sha256-n5u7dzAnZ7YRGIC2qyynlsALR7tONulc0ZmimW+xotk=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.6.0" "sha256-mjY7GbQ20pzL38tQMoluJISpaxk/IreluvmX7XsLfTg=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.6.0" "sha256-8kK4JurIaid4k0BkpoZkaosn7cOIyMTt0RXnoJZUtSc=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.6.0" "sha256-nUOb5NwCsz/7Z0bUMUsxysn2bgNi+yTvyGGCkwzCU1o=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.6.0" "sha256-Tw+ozecMKAw56x47Wqq3wwwcmDT+5LvoUDAZSX0z2I4=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.6.0" "sha256-QY5tN7QVP2WC7P/se6wNrnLp3sJVIr/rTEs9ePpADPE=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.6.0" "sha256-aedmxGOuU70uX/+bQL8coUWBpk9IQHAL7VqusH8zPbs=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.6.0" "sha256-wyT6YahL3sRGHQcBTAyLd7l75wVWRp2waS+Q46Me/ok=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.6.0" "sha256-mY26ICYSENAruEn4986zxi5R9ong4nyuRAHgMZDliqo=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.6.0" "sha256-CR3Uopf6izBTlR16yIA3CUikWrS3OzkFZFpbJNDhBVs=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.6.0" "sha256-pkZMQu5himEPO7z/AF7INb7H7jjmkyQV1ql2epF4yYA=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.6.0" "sha256-sIQ85LzkQgMvVfAKEc5HxIXx85Tckx4HVXcex2hxZ6I=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.6.0" "sha256-IZvLF0Wg7od/LqC2bcCxtvNun0n9JViuXE/CQMoBdMc=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.6.0" "sha256-9eebhFQqnsParfZ1poJJX/ehx1lNHIynFwXEzAo10JM=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.6.0" "sha256-ot+oM2a+CA/92d+tY54tqdOlsZWReknv+Pt3Aw8V1GU=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.6.0" "sha256-iNlzgcjg3VrIZJEi2f+7msFqrfWsUS24k7OERB28uRo=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.6.0" "sha256-1exWgnbG5ikd1pHWClPGq3Luku5qyTtG6pwvqL/zWdk=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.6.0" "sha256-0fLwCr5eDRxcGZdw3sqExh8awX1qu5XmEYMD63xhD3w=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.6.0" "sha256-eiibXP8S+xvn+PTX8cd3WiN6yL2JmjK9EG9BryexFjY=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.6.0" "sha256-3zQZyDgaMuj5SAQ7Nc+XzF5dUi1E9bAjv9mIscJxfqM=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.6.0" "sha256-qyA1uCrAFGZHMlfL8Dou1YkM6rb9xwcrDQmteSqOadM=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.6.0" "sha256-ilPodAPj7J6xVCPEjsBQcQ4I5dNMEM2/hM1j8PJMUto=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.6.0" "sha256-m/13nELWqdPNkZXmA3FhArlOKhB1CcbTaAsI9Iqzrik=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.6.0" "sha256-gW+GFoQhI1Mj412Gh3MXfoSMKpNscUB4AqC9WMF4ACI=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.6.0" "sha256-DoFG4FxvJFnN54G5F2LZY5M0aYlCU9H5wwnAsiHaRmc=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.6.0" "sha256-VZajCqSzofQLUBrXbMzdaPmbIDNp5YuUUk1wberVcFs=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.6.0" "sha256-gbl7jEgjk4twoxGM+WRg4MZ/nkGg7btiPOsPptR7yfw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.6.0" "sha256-IX2KY/guFLJ6jL4gRdTS6cQbNuFJuz8xa4QzqZ8j5h8=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.6.0" "sha256-k/J7hBJDfGXMFR9jn7Tiec8bClrXIz6XyLMqLJad6oU=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.6.0" "sha256-swmAlpVrP1eSvJatWaJL6QDfgZ0xzBttrpHt1aNULUk=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.6.0" "sha256-9yD3FIFrRDMAckbztjrKeUEyXCUOggF5UfsPe5hcQ1Q=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.6.0" "sha256-Q6S9pTfquW+Hv4uB9tbS/TEsC/i7iDfA+LyZCHq3cRI=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.6.0" "sha256-iyHFWN8tWgQoShTO6bJQB89K+4JVWjMihzjMr2Lssvw=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.6.0" "sha256-hEwlISpSm6r+a1MXxSH3UrBOiNu+Cx9d1T2RsFfrcyA=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.6.0" "sha256-VdxG2yvN6g9UAn54OP6uafHGN+iHjNrfO4H5f5h6w18=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.6.0" "sha256-hrfqkhKWIcP+fjDaeFjvk6c6GBTgsY3yxPodx9fFpxk=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.6.0" "sha256-c7XLKvwiQL6e0tWH0DmOyauTz3q5b0hOVpjVzR1rmH8=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.6.0" "sha256-zw2mJFQgX9xqjsvldssfMeulgCEY0kqaNg+nUe9PpCc=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.6.0" "sha256-fdZn+f03iIzzkpSCdTh2uUY4WcU1DcyRxozP7SSkGyo=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.6.0" "sha256-KoZKeJPlIWhgifauIOSSLZaSJWn3E0lSNUOhKPfI0Go=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.6.0" "sha256-HT/Kvi15YJLEno70ayEXQLPi9Y6NlRD8134IRJ7gdRY=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.6.0" "sha256-3F1Gpd2kOU1rS7iSyDr0pkRECqYsyeeEQKDH2OO9H/A=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.6.0" "sha256-zUXGqquEveHHDqA8XeJX++Yc42rnyW9Vzt5A7LOImfk=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.6.0" "sha256-FJ9aeZRCY+bhot3cU3qX4EuFAowPCc7kT2D0FGVTpys=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.6.0" "sha256-WsWw1y5XueMQnRTWYQP73GawsSzEsliPzu9Xlij3UAo=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.6.0" "sha256-7wvX7X/NdB+GlWDogT2benTSC7ZCdVv97Zi6r+s5B2E=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.6.0" "sha256-e6TTldFkZXf8A8bV7RKkIl6AD/lCC9elB6mT3WeWEiM=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.6.0" "sha256-HVoia2UZMrjgH6aUQGit+MueUk0qW3KjWKYJy2pHlp0=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.6.0" "sha256-hXju28oSNGlQ0qCwFD+qoyWFpKMbFkGWEXteOVOKiII=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.6.0" "sha256-mo4vH/xsbRf1UViSRu4P2YzI+7LFkkzXsHeZZLdXg+U=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.6.0" "sha256-eU4j+9z++Kgp2TaUX214XGuIXPxCriKu9w+XW8mZp+c=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.6.0" "sha256-HKolI0fcGWye3Xow73qXOJRQ/Wb23ZXWLYyfA94zZT0=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.6.0" "sha256-61iFbkOYLF6y1QUGePVAVEFqGgTmPbLYS7VDbvzmInA=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.6.0" "sha256-pdRp9XjLVLCHeMSMV+NycKNt9kbH93/ZJKbiwNlb+A4=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.6.0" "sha256-3/LXxvsVmKHpZPr1BISTndLFPmF3LF75kihknSt2cMk=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.6.0" "sha256-2EIBP4NhRy+/OeFuPP/SIf1q6BhlKU9CFH7AM+y3558=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.6.0" "sha256-3bVNQSzaMhkpiN1mhS9Lz2EfeEJpkSIcPCKPC6s02Uo=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.6.0" "sha256-Pwmgi4ybpOtLWlY62+QcBHT0iF/6B4Hxbv4CQPA+7/o=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.6.0" "sha256-x+wmTG6jeK8KpSDdhOZkbkRZ7ai7N4xaU4cEmHhO5xA=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.6.0" "sha256-Q/msYeaXs9MxXj6X0p8Gw08/Y4FvvV2xAbEXU6iqi2g=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.6.0" "sha256-UB0y0l2fb58yNJr36WpCeTDETAcdQkYd2ueETFEQSTo=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.6.0" "sha256-ynRq7qRVNgpsP4lp6pbZqTv3zrF5Zu1v+STvv/yPgKw=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.6.0" "sha256-M2tvTKjIg8aEP3KZvrMTCgiJqb6oWL9T5ylkj+Fr184=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.6.0" "sha256-XY9DqNQUjFaumcOd2dvX/kV2sWt67Ni26H5SzCarr2E=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.6.0" "sha256-k1QO54TXJJG5jAvPcoEyZEdEXSmLzHdSPDyF60Zmf78=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.6.0" "sha256-kDxDdLaWlaNLfSCOc5Kho73cbk33FnK9c12PYKhdbFQ=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.6.0" "sha256-Q8EIdCvT0Zjj9udUNpWZzgNClVjNBWTW3V7emhdf+yg=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.6.0" "sha256-tXAQ+tNeZUF1snrB+76Ku+j1Wdslah38s0YMBOINrlo=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.6.0" "sha256-/XJsZV5Yhp5BMSheF9zVf+MSJsH2zUrpnrkSwo+4PfI=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.6.0" "sha256-x6uUO578BIDl1kFdyKXSPnegKLAX3FG4U5rDjsQpVQQ=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.6.0" "sha256-+eHgcPA+egPBR06Mddw0RXuivpiprPMnBhPfCmh0sS4=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.6.0" "sha256-5s0KmOdQyPtcFtb+XkR/zHEiEdZcDwZwldwUy+dvC4s=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.6.0" "sha256-+9wtXNgXQhACa8NYfcjbZcJj0j9PlOavxs+c4NXy0kE=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.6.0" "sha256-tvLfXhaFpdivIBtFYp0G4/QihOMSGXK1nVDFKuMJCto=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.6.0" "sha256-j0ngXkDGIhSh/b1RPn+NY6V2BAUZJdvuT18iALwRkAY=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.6.0" "sha256-Txme0jlgoF9IYywdKqv71kcEqBfF1juTJcagi/2wQ20=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.6.0" "sha256-c6tqmW7i5AXrH2PFyVPCpBkDaiMdTu2fmbHeuc3SzPg=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.6.0" "sha256-qvVYusxMw+ZrMJAKXqk1HzEDYHsvaUthnYMDF6b0xbQ=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.6.0" "sha256-ErqAFQYtKfsNABPm+KpOKm88Mh5MmXou6bqJfsqXdt0=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.6.0" "sha256-vOszu7z/DiZwXrdqoiLUlpLQLNNuRbskI59BBippizI=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.6.0" "sha256-AKP23N3xMzdOti6J7vONDM/cwdqTHYkiM6c/njspSXI=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.6.0" "sha256-PccslOI6F2k50g03j22AYN3xtTsTW3ie4W4pEaT2XwY=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.6.0" "sha256-3e6/IA6QYgGhipt5XP/b4h3soko1tLntMieXOmeWjlI=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.6.0" "sha256-rtJ+idGSdRVZafFNppQgIQUobKzClCKHf4RqlBtppBw=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.6.0" "sha256-AqV8yAUYTT8nc3jQkq0qDzZRKxewsrxIR/kVJiX3fwI=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.6.0" "sha256-N4YntFIEyhhryAaIFY8Gu4Uehw6D/VcTeIlBxx7ej4c=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.6.0" "sha256-DOum/vx6URynxImQN9SRhAr5rFgZdSJMdtAMom5YHe8=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.6.0" "sha256-pZ/h8/1njNNp9+nhpbU/VhGevrZkSrWnhWm3weHAxWQ=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.6.0" "sha256-TOI2FQdO71XT1NESXGrZN+UI6c7CGRmsBbp4ipuQwhg=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.6.0" "sha256-M0IDOMbqGdLl0WSipPirjDn3Fr4AQ06+j3m0Ci3jyBE=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.6.0" "sha256-GYddRqZeBP5f6chzZON9y59KcBiss9eWa8rVGo53C0g=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.6.0" "sha256-6znZQUxNKE7SB6G+9l4iQSP9hZt+plKFA8VkE1scxrU=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.6.0" "sha256-FRJeBjA5dfnnZ586VShmPt0CBgi5+ZYbldOUZIGR2L0=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.6.0" "sha256-lMNUId8z4h/m0FmusvEjYoQj+PUSLaiOREd27vF3qxI=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.6.0" "sha256-8luG3yWj82hmMq5KYjNG58pbiDBMk+D6ykgzqE752T8=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.6.0" "sha256-nXZ7ZrpEOSdXdcuGVMNI7hjx6oisnnej18vALIEEzGQ=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.6.0" "sha256-cjBd3Ns1ckr7DT9gpaeb8CbXOrmwU3gENN5Is5BwrZI=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.6.0" "sha256-GcbI21WVdMmwMcpbBkma4VrLsLVRP24/Uk43+4vE864=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.6.0" "sha256-pW8/wn2Qk1jf1d2kYZ84yEaNUcl6xgHw+yuT0bHnsBE=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.6.0" "sha256-aKO/fGT4UANiYkZOUuOQ4ungKpW8p+yAT5+42WHgp3M=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.6.0" "sha256-jTAe8nMwbXwb+1uf9ITVIKtKyOLIwFH6yi+2IYYVIyU=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.6.0" "sha256-RMIrcFD+1RbA3AcRw3TSjENBzmHQL1zHX7FoOFA+UP0=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.6.0" "sha256-mBwT11n8moLt/j46AayYES6rjVo3Tpa5UWJ4Klb1N0g=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.6.0" "sha256-qYYT1FRpqxtR9LPGMOH+p0+kbeGvfrlIE6rp5Nupioc=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.6.0" "sha256-66kGFeDv4PkKYd4UEL4Feqw5LnygBMGvHqctC4EWnNU=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.6.0" "sha256-TQ7aNPrky6O+xQefuSkHyFN0XJC5u3xMaT0yrjwYv3E=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.6.0" "sha256-55qUjFm6ryLjGAmxGLFkl9dPHXjDWyIINZQRQXe4bnk=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.6.0" "sha256-e8LzXHMfEgkcJKx5a/I//L4/oCz1l7N487wNoTtBP1Y=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.6.0" "sha256-MIp/lGwJah2Jj/2KFfoeW2uQlV1DZbP8TYcdsNvEMU8=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.6.0" "sha256-eyiAFFT5KOtTDT2EZNah1KRdcWw1v1titjHwG3DnRj4=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.6.0" "sha256-g4wAsVc3gqiovsXZtEey4XKmLp/UkIeKD1pEjiey5DE=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.6.0" "sha256-GUcRyWviI+JCG7XTGBQcUljxAdjBzso76d5A3ql5lbA=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.6.0" "sha256-7znJt8gJGnBbTndTPeFOpN6iytOPTJPgvA/tHeYQVoo=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.6.0" "sha256-O3oCXuvREHW7lcwDzbJRogb9Qa2Wfb8C5/rbpjhVm8A=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.6.0" "sha256-mcU7ZGAGzbV7i8H1qMWFI9vm/8APRfmaAncxKBJL+NU=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.6.0" "sha256-uKvgKNZHFZIYsE0hMWjuHN+QzI/eQcCn4HD2C8H+d2I=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.6.0" "sha256-Hnq9JAdPiqfhb/uLQhMk7JWZ8xHko06KqHXh9f6al/8=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.6.0" "sha256-/7Zzo383eWFjEHxZST1QKzTNHunhR8mjSE2uEHUw9IE=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.6.0" "sha256-6sIHmILzIg1aOskXnjbDDzbkygXDwFcnd9mfuuhRFZQ=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.6.0" "sha256-2BnFCPgaAWxBsc+79oQT+DDj6IM7cV7F+LjqsFG6BBc=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.6.0" "sha256-TW57DJw0QgnPrIWlOlAvESYSEPUD/UKbXVs+NYW+7r0=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.6.0" "sha256-cLciwg4d5EZKYquNitl3yD+8eJnemEiF27LcXfxy0Zs=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.6.0" "sha256-dvte4Yjl+a/UqL5v7xJ9626igVjx/ZPdM2SsLGsVdDk=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.6.0" "sha256-36BIOCHnkFyEp3MPa5NfjNJNBeqVMCmx9C907Bw3YWQ=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.6.0" "sha256-DKmk2ddd7b0g6mnt0d37Y1ofb6dgN/6XFBCElqdQ9+A=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.6.0" "sha256-PRzh/JFCHUqXTSAR4IoftxvkRBsVq4XEX7ihC9FzqSI=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.6.0" "sha256-GcDl3LIy+urPEzXINmU4g7xgk8IIIJ6fBFFXhv18eSA=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.6.0" "sha256-5IoQuLh6bh3mlzInR+Aci6yIRCSYJXfbvv49FEs2tPA=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.6.0" "sha256-l0xrQXkDYmB3+RFtwJ70l6GgKeA0z1V107HG8Ddvb8U=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.6.0" "sha256-KLdOmaO6x7AmQInP1RRAf8s5rlpD0PpDHeBnor5gl2A=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.6.0" "sha256-QNjpM0m1PKSQx2f1eNkOeNP7pHN0PfHZlMFVQbGOgGU=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.6.0" "sha256-5g1LUvS324evqH+Rv+pUKlePnE3QqMqpiLCrknxjQX8=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.6.0" "sha256-5NbnrGPo9jTCIxq7ubNX/OuKZOXU0PoSwgTjfuMvnKY=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.6.0" "sha256-AZRsUZpKhzPiHoUcboBeX5zYlVD9kY6F4n6/ifRTpr8=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.6.0" "sha256-WrkKQxXI7eIaX4GimyDyBqDWVjw0eF3jJTA40JScvG0=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.6.0" "sha256-I//ZK5HolYkCfpTCPYhEDALfcn9AYcLk7x7vfRjTDlo=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.6.0" "sha256-Qz+ZXVBSe3kHgGlqQjgxWoQhnguqauxmPKaISQbAG/8=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.6.0" "sha256-Fh35RpHExkL/PeqEnWNR2pJYWERDJzOF9oE3SvIxxQ4=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.6.0" "sha256-Wia4Xc/Kt8j6X5rZ9vvxupr6tCv1XQQQFOwRnugL0lE=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.6.0" "sha256-hDPU7e14iYcpt8dXzjx7PgT4TQloAn2ZYrq6cMtMncc=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.6.0" "sha256-J5QSpJQjhO6T2uGpDstHdEVJTLuTIxilmYmKdtB7u6g=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.6.0" "sha256-NxTwgcrDNOHZ8PReIgfTOGLTl7bL1948NKAyjJ0QYKc=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.6.0" "sha256-fWnCKnG6ikXzDx40HFxlh9DyLVlX9pBB4CMcJxUt+Ps=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.6.0" "sha256-6wkvuRGT91a0Ggxt13amMzjWd6Pj62w4nrvWQNQ0GxI=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.6.0" "sha256-7NkEDcuph8xxjlDjuEiSuhvM5srAeY4QfAKLwFLhCsU=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.6.0" "sha256-pM6yxg0MxTXjSWZ/CLsatlIMx4tO0p9ZKRzOhyJYXWc=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.6.0" "sha256-idc5d/Kvjhd7RkTHuErSoP/f64/Q1+jg0TE3UMiL4pQ=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.6.0" "sha256-3eJaNx/Tzy9XQtHSPGKlkMG7klB2KDgL60knGghWAn8=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.6.0" "sha256-7y8SiLa09lDqnMZtlG0Qw5tvAvQMvTNqMuCpRecOpXc=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.6.0" "sha256-Umq4Slts9RHPJRJCWRAIAizLxB9Clcz8GomLsUr5gNE=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.6.0" "sha256-iRwalkojzQCUiAQcxl8hEYFFbnIxhuaJfrATnK18ltI=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.6.0" "sha256-+4rnAV2Qr29bvWRO6TnSaRZkUVCoefB3SDXc2Ye9kpE=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.6.0" "sha256-CXYfdtO1TdmEz39v2AEeCTJmgiA/EF1gmaBBYGRgYV0=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.6.0" "sha256-x9cBjUe4LC9uSsFpPciZP1QlUEqfNo3xZFKUqPuVV6E=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.6.0" "sha256-Wew0A2xIYOGXzfZf3sBpHnRW/dZD1s6wHveNMwYj1s4=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.6.0" "sha256-vWUMopzR+1095nN6POsHShvCKZIcUwfW11oMOJ9R94c=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.6.0" "sha256-4QpCK14NogeYR9DB877zh760GEXYieiyOgepB9DZd+8=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.6.0" "sha256-bBcMTJOVFq1mJQZtc9M/EMT45Xxxk2DqDgVHfM3qt3A=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.6.0" "sha256-c4Y5kilT50Ips16/YhwduNbm89gB4iLHFv8eN8T4NDM=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.6.0" "sha256-HB1CKe9mkD0+0TdFXmdiphDUqc+4xbwBIXSu0PulBE4=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.6.0" "sha256-59SvnKQ+WpAKUZNYunFywLLah1aBnF0maZrFbALXcIM=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.6.0" "sha256-cgxE6GYG9c4234RAiyFfF22NPHJ29oytOvLpETnjdS4=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.6.0" "sha256-yg4zDBjgSB7JuuS2DXIUe3PFQq9stIfEJSMF1IP2BWI=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.6.0" "sha256-Pnn3CGL5rr3MtzaakjDXmReVKXnyB76IxSnAPnKU45I=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.6.0" "sha256-kxniFLA2e7aDKulF5z1Ap3z6wbE3eY3QVqhK+CVhrcE=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.6.0" "sha256-adKf+AbPmeN57r93T36IewoiLZ+05CbpuS7NxCkQgMw=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.6.0" "sha256-56SIq8Q6B405aqKU8UMddGHyrJeFaVKZSG4ImBWBZLU=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.6.0" "sha256-nAGK0tN42UhDUmpztGeAPRS5FuuTt+LugQmcgkR0oLA=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.6.0" "sha256-p/2uqdRwKgsS2EUCr8ZLds6WHUjVQz8mEv35qcyMTYA=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.6.0" "sha256-EInqI5EqriiI2L/tdQiy3/jY8tnZ6+QOk9PdEyDuSj4=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.6.0" "sha256-cNegCM7a4QlI+NLzIRIoGHYzQqbFkNRKqDKLOqE3OUY=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.6.0" "sha256-hMPU0wmTi0BQ+AWo4T6DIOl6FrAQbzdal8rcPoY3wP0=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.6.0" "sha256-W/kHZMLFQ7kv8i/3urxbjdXc7RorMyy5joJNtFPAhVU=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.6.0" "sha256-Mc3h0CSmJRoV+ncwhtd4Tu5LSoasWqK8V9hXK5+XYfs=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.6.0" "sha256-xtsxrIzhjJSoGqd1fEgXP55bRtDsJTtdoWn8eooHCmY=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.6.0" "sha256-J3lsLnwcttamV4NroDuXz9EupXrsoN/SumKrykQkwVU=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.6.0" "sha256-DPirH1s636ZW6VKyD4wMiJEfM+u9NknH0ODLQagaLrs=";
}
