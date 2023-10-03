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

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.6.0" "sha256-DPirH1s636ZW6VKyD4wMiJEfM+u9NknH0ODLQagaLrs=";
}
