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

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.6.0" "sha256-DPirH1s636ZW6VKyD4wMiJEfM+u9NknH0ODLQagaLrs=";
}
