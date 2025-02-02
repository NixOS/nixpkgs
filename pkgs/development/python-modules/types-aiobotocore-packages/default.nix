{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.19.0"
      "sha256-7sBsKHSUvpUvvhb5wAbAKUVL5slNv4D+3iNuXOi9YLA=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.19.0"
      "sha256-fYgeQo2ndxqGudPBOHY/JucMwVMHV1NH508n+FO/D1Q=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.19.0"
      "sha256-EYlqDUw39w0/QPweGLmtGy/2BmEnjZ/Sb98H6X6JPek=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.19.0"
      "sha256-aVfkFfd50kXMz4O7E0ZVljdUZJ6FtW0dlFcnBBFRXp4=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.19.0"
      "sha256-frL+ub4KgOgE7s4OHkqvMbd6FPnLDrvparwIqgwN7g0=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.19.0"
      "sha256-wncHuQRa2CZiJtGvC9ydk3V4lZr3ewwDR512U++pLo8=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.19.0"
      "sha256-uadz3J2pBbYGrAE0G9yrtKKDsAFf5Qizuwte4geU5BQ=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.19.0"
      "sha256-ghWvpii9o33izJ2R8mYsoEv+nRtF5AwkHXEVgB7rp8A=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.19.0"
      "sha256-RcaGKBDWN569rEO1q/PLHLUx/bvfFNBPWu1dTzjGw/0=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.19.0"
      "sha256-e7k2xdm9bdiK80DgbvskKKkpQhVkOGQcVlsJjbuXAP4=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.19.0"
      "sha256-jCc2N1NI1RM+7UnH2bx2InfyatD1zhALQwBzjax5Q18=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.19.0"
      "sha256-gc402Bx93xWxd5lkTg1IXc3o/yHcEqHENicibZjARnY=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.19.0"
      "sha256-wdmVlym+MGQE4ghIkKT09SUTRgzmX6K7aUMBEOtzf7Q=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.19.0"
      "sha256-LF5lXbvQgDjnO21ZrMFhdFNgPQc1np2aDq/FD4c+Te0=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.19.0"
      "sha256-1EmvqNJ7305v/XOEKoK1+pIFGjIEqKgu0EXmbIBYKPQ=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.19.0"
      "sha256-ScnOYfYeZOpa8h65aGar2BdxXNywA2UcySx0TLxI2lU=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.19.0"
      "sha256-mWAs9zC9D1v1nwYTmOQ5HwS/rk3xGIqPjcIzL/L6OBs=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.19.0"
      "sha256-euWRlWccaqiaIuELwijJo+zNBPUj79z/wqayOWb7Gr4=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.19.0"
      "sha256-5fAI6r0/X1J0pEf5RX25wib5u0PowZWkye5hvbTsDiY=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.19.0"
      "sha256-5iENUnL/DE5GIxtR7Em249T0lwJU+ozxOlDdzZF6T58=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.19.0"
      "sha256-ByUoac/3IQX8LwvB7YHcbp5HXne7gh2JM9qThb6OSKc=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.19.0"
      "sha256-fQWtyOYCs1L0FE9z4+WfeRTE4/HuVbKpJVZxkluWdLA=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.19.0"
      "sha256-im9jb/jjWtDDjstxUX7SRFD+9ukfHnYkDyh+O7fPqQk=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.19.0"
      "sha256-tjsukek9Kij/R+9xgAuJL3e6KNcjMODav0Grg2S4hmg=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.19.0"
      "sha256-FwreaQyzLoo+xlXyk1RvARkguRtn3iVN4qBblIJQmKA=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.19.0"
      "sha256-D43pYzMiEnWOmgm7nP+o4EBa+sEV7pEC59ebpwfctLE=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.19.0"
      "sha256-YMRqSW6q+MokgQ/v6/X/HoXUP+Vb8uXBAddM5vE0Eaw=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.19.0"
      "sha256-SWi6lVatzl0R2LvYabHwVTGsyPBoU8ETQsnCUgPsYxY=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.19.0"
      "sha256-TurRscROTyjAaC+2ndbzy7eA9SB+pPxC+Uxr5fyOfNE=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.19.0"
      "sha256-P8rkyw7AQT8fOTxgbmFmMDtltsOcEFf69YMqy5GEOSw=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.19.0"
      "sha256-8C3YyID4NyUqBFYj23yRMdFfRL1aPP3GyPxG8zjzpZg=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.19.0"
      "sha256-NcUvuYtEDdurcKeM3OpJ+gr+7P786uFWMoK923KiiV8=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.19.0"
      "sha256-BxsWfZ4t0LOydxHKMNdLvGN5VjfQSyOF/9MeSam78SA=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.19.0"
      "sha256-2YtEBvt27E4SoNa85CIU7fQwfpqd9uh0phP+aB2IJ18=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.19.0"
      "sha256-R6irNHx+esAUxP2P/8FMcyqY9r+bHjMc8kTCOUEpsV4=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.19.0"
      "sha256-yobRsPta08RlGDpCbRWfGn3jcTEgXvuEcrZA6lGP074=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.19.0"
      "sha256-juBYpXtLssbE+K55443YzWm2WorhNNUuKFAV4SOSbB4=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.19.0"
      "sha256-VlIX0mx7/Zj7RK/1yE4+flIRQVA2tCaAbWkd4qrPUGE=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.19.0"
      "sha256-VP8/aLgSBr/c/Jo9dyF5FX2l0j57iZMZ4otBQK0HiHI=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.19.0"
      "sha256-va4jkDcdwkOSkw6tasMdaDy7ecwtQXgt/yiTl9jmhi4=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.19.0"
      "sha256-B3W0xp/ZoCufQXhsaFEUtIh1OrONN0nSHCFHLLwsNB8=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.19.0"
      "sha256-qbgtlrfpYsDoYalyldzRkoCYMcT7fCVGdnsNKvCUQT8=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.19.0"
      "sha256-DWOiuyi6PPddvZ8yrlLB3m0AsbPhTKtNCpZ2NiRybsQ=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.19.0"
      "sha256-vJSeATzeXQVg/C3GtzrbQMLRwvE07I0d16uEVVPuo6c=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.19.0"
      "sha256-Avvwe1hWj39C7XwJ0OG4ohW9cgf1l5shRlupeTg/6T0=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.19.0"
      "sha256-3ts/ejg+RCXakuaNdPtt3f/6QAgh7iX0R+YfWpy0UgE=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.19.0"
      "sha256-Bbzj9oZQwwNqQjVWAQEieKjQ3ttyI9byFA2k7vAUWV8=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.19.0"
      "sha256-RpAjyuD2wVx6pHEK7fSq1whYuDYRTM+MYhapcMl4b5g=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.19.0"
      "sha256-qfCSbE0yjry2EGwBCfwaIqWQ0DFRcXnxYrMQGs7EzUs=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.19.0"
      "sha256-P2SGtp9aCXNa/k9OEQYRiQWg5U5/2ikKt2kJk6UOKOY=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.19.0"
      "sha256-/nAptQRuqpsTtrj/nutUVHR2FybVvjbZGXVtu7h55dU=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.19.0"
      "sha256-yhT1elbEFcyXAlnVx4s7/vSYYvoiILIIUuJ03/tZN6Q=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.19.0"
      "sha256-Heeda6cq7eIhPGkZGVubVlNYTg9/SXK0jusq1zk2DSE=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.19.0"
      "sha256-nKu+N1B5hIdeHZXokM5OUaH30Yy9N+WpRunyVCZ7fN8=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.19.0"
      "sha256-NBYaHwzyhQ8qM9fZbonYHI152O83FWoo3j4IKNyJ3oM=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.19.0"
      "sha256-KFqiM2Y2CQl50CwWLRpkAt/2uraeWY0OpTWticsUpqo=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.19.0"
      "sha256-qmYJPnqV42AldR4Sd1z4d6J2iuVzX1p4jpnsOl/ulmQ=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.19.0"
      "sha256-M1TF76EXl9gtjUarx2b926pM2jLmnxCwpjaz8QDkVrk=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.19.0"
      "sha256-WbFoGbZIAvrwSbOjWjP5OhiWCgq405zAmIi4MyThK1o=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.19.0"
      "sha256-CMLoETHaz/FiXZHmaBF+w+KSZ6B+rGWrGvQ3AqaGhdE=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.19.0"
      "sha256-Vop6p7QNdOfR5z62/QZgVaoJJDf11erZVC9wYGgKN3w=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.19.0"
      "sha256-t2+IQJrS6HgywTSCr9I6R4oXKJHH5KLh+0wUJlLCQp0=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.19.0"
      "sha256-CWXEuawC+K8eKC1LPz5LagWDAZyMt5zGk9gx6EGjWoE=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.19.0"
      "sha256-ATTk1A8kEgl/Us5AE8pLXKrvR+MNKJJD6GxQcs5XBJc=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.19.0"
      "sha256-/qQsWwGSeq1i1J1ixvsIKNM/mwfh1/toEn9yov7jfm4=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.19.0"
      "sha256-0JP5o3PKNKhnxmzlOxkgO8qv3QV2am096wzr4RSitls=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.19.0"
      "sha256-SyVfx6RLAQd7koj6978uhwndiG+iie5ykLUMqKTWdqY=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.19.0"
      "sha256-YC1XTS+kkcFA0TZG5czj09Nam69n5NVfb7PT8eFMicA=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.19.0"
      "sha256-imz0+Eaz0kHTfVAZzFnJin9kgancP9rgP6WQ9nOKeiI=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.19.0"
      "sha256-fs+EElAynBcl1wFkIZ7Zdqsehq+MptXBI3gHchvn6do=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.19.0"
      "sha256-1BKmabzHhcjwVSByFinZRNLsOLgH3KaOLhgyjZnuVlY=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.19.0"
      "sha256-60HC1AwrTcq2SObqk+LFpliYVpr1aeQSan4Ool4P+oM=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.19.0"
      "sha256-uQkjAnvnpxlGpsZYH175oLDDWg7hZFVSU1gE+j8ffCo=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.19.0"
      "sha256-SU502WXqQidgSPbzolxBbdms6vgyXzRhofOYjM0GO9U=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.19.0"
      "sha256-1iuBGIalb9r9KaqttjtW5hcIJRdxa/YSdWyoo2kTBQ0=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.19.0"
      "sha256-x/ZeTXst4MZ+YngYkWEdTxBJBguhYyMFMZtrUZC5lXE=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.19.0"
      "sha256-E4q6VMcUJj8skdibvXnVwlCv284rAruwypkarYmbyw0=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.19.0"
      "sha256-ZRx705aIg7LfSlJXDztE9y0IUmSdOD8bwQ14846V8EM=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.19.0"
      "sha256-+gARRX22u+I+9yYzB8G/IIEyH5ALMFUsrr5aClb0CUI=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.19.0"
      "sha256-yp1m/O9aun06NVsHudYYvnAngnenso4MpHO4Kh2DabI=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.19.0"
      "sha256-Av8mXNJGtBKCGQIdeeSJWz2Ai5dQHJLmRjL3a8/yDR0=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.19.0"
      "sha256-PaDiJ+eh+vT/Qv66PoxDsGi58hGRZ0tGcs1T0Q79DJo=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.19.0"
      "sha256-bqqMEfnuqKlkayWrBQccF730GCNXXhTavU/oF2p7nic=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.19.0"
      "sha256-u9auea7AvHNzQkCAJxQ3iVwJX/gU5XYjKY/aAOUlh1M=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.19.0"
      "sha256-cjmSX19RcSddSmfsjYfLbnZESXar303tOEAQpdDNznE=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.19.0"
      "sha256-WcPaRTzj+D+ue8FETH4HstyRCMcGsa1JheAw+PNeo7g=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.19.0"
      "sha256-RbjESkbraiykDg8fJoLZEgsQv8bl4sXZuiYikpekNo4=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.19.0"
      "sha256-r0fo7uo61Z4sNMq7ODKDPF91930KVt538KjMLzbk++s=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.19.0"
      "sha256-TQL4SDzz7V1vYVZQPkDb1KuviZTqsdB4PTRHwNm1LvM=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.19.0"
      "sha256-hr6fAfitk6B/b5s3BTxZ7EqXtSjR2bPmzD4/ACldZPM=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.19.0"
      "sha256-Mycig/A8vFGLag/0SgYyQvO8F8lPypRb0Pv8a7eAKsI=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.19.0"
      "sha256-fJ43Y3Q5XhpIjZ6M8WPoJ0xyTNTpRbVzDD+rVuSEWjU=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.19.0"
      "sha256-LwoPkpUeIVSZjPbamhkElyNw7vNBAucDkcHhffqb/6I=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.19.0"
      "sha256-CP0BfuJT7C+KGoQtj5WKi5r9yjSrkSkeBpi3oIJ4SFc=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.19.0"
      "sha256-8rrwzKfVdwNpTwro7d/r7sKvRuOY20H0AfatsyjC2cs=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.19.0"
      "sha256-MmF+XrYe1pwEf4V7sXSbQ3rKbZ8kNDNn6dNqOHS5p6c=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.19.0"
      "sha256-ZMiJylk/p+pffmp+BrbbG1WQavSQvN8GJ7C67O7HjUg=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.19.0"
      "sha256-pU03URatA7mmowj2TgvOjtY0K9y3eHDximYmNthmV5c=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.19.0"
      "sha256-+mlMwV3H0zWvf6WzRNLS6LgK/6zD8uV22RLi4XgJiLM=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.19.0"
      "sha256-0aWNKMhyUIjRHhHxGiK/HhDH9HRanF4dc6TAuLZYoLY=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.19.0"
      "sha256-0B7ozylEVL6j2korGV3cQ+UVRVQcWYTgTvquKJnfzsk=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.19.0"
      "sha256-93kK7E5z1SuQ1T0PHHBZUY9YYB0Xxv61bEC6N8QUSLQ=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.19.0"
      "sha256-RBhw8O6cyxc6DcpK1l0NL0J6X1E+XF9Fb+D/iZdyLHY=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.19.0"
      "sha256-HsSflJ+l64UE4tYrYnrTg86sXvZNeEpx+2uQqMZnKcU=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.19.0"
      "sha256-Ys+R6egRW006jmIdxzs8XsdnefhJA8AUo8niAkgfZG0=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.19.0"
      "sha256-9gN7akmTVum8qbe7ThnWSkoRRIkXWfk9GCBURMNFYGM=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.19.0"
      "sha256-awb5XRYoxj+WV4tQps/Y/KC5YrvsCt14T4dC50FUSMI=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.19.0"
      "sha256-KqA1t5KaHDAbGNjGGwyDO339psI/RJKnNO4DTM86lfY=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.19.0"
      "sha256-LNtgKaLJuK49W6krMXQ7xzvE6HAX/xKiBnp+iRf5G1Q=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.19.0"
      "sha256-nTvfE5k8HSlUPJb980yWTiSV1fPmFRcpuV607t+I5mQ=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.19.0"
      "sha256-zmXOhK1F9HaTs3YLx3MCGjqgBuT+P9Ktt7zdEwJ+4wY=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.19.0"
      "sha256-eOqXgnR8NqhUdzvqDo3cgswI9RrOiR2f331H/glLUqI=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.19.0"
      "sha256-3ze/fZMVe9A5fzscq/oudTCxnmgyCJ8+85k6LXzztk4=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.19.0"
      "sha256-G7rdpmrwzWXcD2hDG4+/REAYbWY6VcU1gxxqsgVXrPU=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.19.0"
      "sha256-6H5SCq7Ia2nyfPWQ6Xj0FohErYd7CrFEtTB2vi1od/U=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.19.0"
      "sha256-bZ5fuQ7xpFpHCx/eSBCHyRPzf+ThxzftUHX+0fciD+w=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.19.0"
      "sha256-s2yOknGGwstjHAglE3qYO7y9QHdzFoNST1THb4CGT7k=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.19.0"
      "sha256-YeJu9iggcymo7jjdtn4tPJxR8mlIB/QwZxil5Ps2Vdg=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.19.0"
      "sha256-sVLZgQ3BD7kxjshJv8PFfWeBzRZzx7yTZDZP7GTtiNI=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.19.0"
      "sha256-g7bcklvl7M+0tvdQGVzUpHfZZnCu0jN/7GMK3I/1gRE=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.19.0"
      "sha256-3OcPuGbXK+MJQgXZ2sC1qYO+j5Qdupob8klQNqmiZZU=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.19.0"
      "sha256-t+rZZXGdBrXqBsPmkJOI08C8BtJyWMThVhIcPOtZpoc=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.19.0"
      "sha256-E0d7X7QVurca3t2dJcw4humDs+5vJyG3dhhMrotGR7k=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.19.0"
      "sha256-37x3FWOOkr4EvR4Qcfnc1MgQBKjQBVSjxOSdLK+roCI=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.19.0"
      "sha256-yIA8Z82j745UTs4PGcEuqyFHrarf7GgewyWS7W4h3To=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.19.0"
      "sha256-NMtXfLuGqT3SXGJoDz6akqr0y5Q3mL4Vbqz2XAtlr00=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.19.0"
      "sha256-JqyHM/x0taLX7MKdhA+x0nFwix2OrvYqlvYJp/NP/qw=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.19.0"
      "sha256-JVPubMEw42SKPIqGOnjvLWT3hrOJHhDYFYCAw+06Ags=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.19.0"
      "sha256-cVXTRGcBOp9pZEBxAoV97Rh/rgXRAwxuooN8X8jTAHQ=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.19.0"
      "sha256-K88MkKKx6dnal5FIkv0IaMlfd3j2ncE+P8q+sf/xmlE=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.19.0"
      "sha256-Qfb8la9RXmYnqyvPt1JqAH8eU5VoESM5eVf4RFxoGNI=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.19.0"
      "sha256-RvO7bnwmDF8CSPylDs4fFSrX/RGqMX2tEhStAogLjZc=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.19.0"
      "sha256-jIjWXbhoIRG/rRfjMtH2ZaJmcxI92i8KUQppC+HcB8o=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.19.0"
      "sha256-t1VEYBcM4+AgLqG9XxRSK1cVpCmAmzx5rDHQwNcsFt0=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.19.0"
      "sha256-kSEGU0p9pU5XN8cxztC1ZzzcFW+11zDguLnlXWpqv90=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.19.0"
      "sha256-G4MgT4hUmF/wRXm/qusaS0t9B8+TtSGb5QBlka8dlUc=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.19.0"
      "sha256-vs+W4b44J2EAPQIJWivCBypLI+XMn7u5RyKtD/i1T8E=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.19.0"
      "sha256-9EsVh1lx9DY/ppCfig8dxoaLCyWeHdM5b2qmt7gudNQ=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.19.0"
      "sha256-+XFeUxzocoCNtlrIEsmEZTvzS54LdYloyoPElAJAptg=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.19.0"
      "sha256-QHrj394wHBCrMK1BRLP29T1i5ayOE4QTZcRmqNj3Dpw=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.19.0"
      "sha256-rmAuJcz6QAlaieZ6Jlz4ImIiEruOHkznB1QQlCM8dM0=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.19.0"
      "sha256-lmL20HtlYTzQ9I2+MVMvT4u4IHIMCF03L645Yo/8Qk0=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.19.0"
      "sha256-s9oDz0kzJeab5zAyueEHVV/jkJG4hEZHChm1mAXkjP4=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.19.0"
      "sha256-FXdepq7oGBJU0ar+f70yfScZjoiEKelVBeZpxzcU9MA=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.19.0"
      "sha256-gOA9eTUfYPjdF4NBggzEujQw3RumbmPJDHmcPjeBDtw=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.19.0"
      "sha256-9TBhWIm02PzQFG9tHrfXg0CVPyDGbVktOZQsM/RsvRo=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.19.0"
      "sha256-6hvuc9QJtLH+M28JtUSF4Q5xWEHZAgmhfdpide9NQyA=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.19.0"
      "sha256-4XVVlyjrMVZy7vowYFKnzVuPc9CwHiTMYgCoB3612wM=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.19.0"
      "sha256-Ma9J3TE+zZ6XddIpsI+Q/OVXiEnTNGVSNuVBNbA9JSg=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.19.0"
      "sha256-+jTy4IGsSrx8KgyFRJkHtp6ZL3urcvv/SMmNJJOxKD0=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.19.0"
      "sha256-34Q+bL6tkIdORuYxZWf0f4806iZK3LPJwD9+/XQa148=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.19.0"
      "sha256-0mYXQt2KLrP4Dj6gqQ683ClsHe1IQaqjeN6P+XBXZX0=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.19.0"
      "sha256-xqwwbVnxTrWj3DKL0WO0JD3vmQ99bPoOCfDvTJd/huU=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.19.0"
      "sha256-qXO+X5taxs5wnv9045BhDgfClX1QV2ME5LJyi6KEqpk=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.19.0"
      "sha256-u2dqgyX2SUBkTtA4Mbts7u1WtwtFMv9gX9NcD9cqzbo=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.19.0"
      "sha256-Hy5ZJGT2TWvN586O4Vo8LZYFFLeiNqNMJaPUCPIZTjs=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.19.0"
      "sha256-lDAwug+mm5a4OBxB6aCc0TTY58lupGoXfD6YW2fI0AM=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.19.0"
      "sha256-Wg/peGHSjz+thnVD7qLZK8D7wDUAr+kDcC4bdCJOGHU=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.19.0"
      "sha256-nSliZvLBKCQFg6IIghTO3wja+7TC0XQQFcCXkjo7pZU=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.19.0"
      "sha256-hOfjLO3QMyd/2Y6G/47TdaTy75/ANHwSERxZXIkwIq0=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.19.0"
      "sha256-fQ9CGWBwimrqoUd1jqz54FpJOz61y0UBFlMFJRtGij4=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.19.0"
      "sha256-y5Qe/sOOF6rLVMbeitfjI5U7apgbRFKUuAb01GOuD2g=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.19.0"
      "sha256-YzbahnDwiOXnE1/2TWLqerWo8BRbnsjhmbKGRNzTCRk=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.19.0"
      "sha256-bdVP/m4vD/IMizd6RC+nSIFntD1fd4rIT33Pes5jopE=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.19.0"
      "sha256-o9gQ4I4RAosmPTtJYXwWQ3sig/wweSvv9dkDzXs5N+A=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.19.0"
      "sha256-t6L579MaNtxzlhHVbOIPTmztmJTcljORgpt/HfS6lak=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.19.0"
      "sha256-SfIL7RtJb5n/Dvw8jsVgLbqKEPjnqNaki65EfUMTkNY=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.19.0"
      "sha256-uyFZxHZ5rpsTVxs8pyCw+QZ3uSXeiWPp/35Uq6QJ0J8=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.19.0"
      "sha256-NfEb7buzP/ZXdrAsvBSQZrVd1s1VjCpFBJijeQW1mMk=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.19.0"
      "sha256-FtjQHKJXinT0CfsdZV/+v84lK8YXXaMaxVy1lgf5q9U=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.19.0"
      "sha256-ONZ/jcQkHWOe6Z0LPa8EVCg5q6jSZ3iOXJetUMtyjEo=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.19.0"
      "sha256-5x8Z2RPVDnTR4Q4fnyX1NCQryny0gX8zuPNYC2A24UE=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.19.0"
      "sha256-priOmLd9q8gFUqknC2WpAvksQR29Skr3DJxtqNJ8o4A=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.19.0"
      "sha256-WSmPkfgftg5n0e793+2FBkWajHqYF5qYMng8O2eqUqY=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.19.0"
      "sha256-tO6/vp8rv1mQZd9hUZZmo5bNVstl9j3Vq+33K4PCeKQ=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.19.0"
      "sha256-DIagIkO4pfPNeNf9jpGBVK6Xnc6AyymZtWHwxGtcw9M=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.19.0"
      "sha256-CQhiPX4n8D4fLC0rNoSmpZdaP19P29MNdx3cpz1JsNI=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.19.0"
      "sha256-Hx1xyjCuArb/8PzRnbBLJyrkFcftBvd0JcYUorgKfqQ=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.19.0"
      "sha256-OBAXdYqIA6faveTGgfrUtBr1qWYrPyOwHY87T1jifQc=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.19.0"
      "sha256-jHxomaRJ/8v0Pb8iOG+Zcs5FgwzVeT5S9D2ZKYP1jz0=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.19.0"
      "sha256-LS3y9qAr72AF8FCrw3sUV9gTd9HxULQ9OLzWpM7JOuw=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.19.0"
      "sha256-i3N92UnxfkaNgfX3dlV869fVwHctBNSzwLxMo9ql3jQ=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.19.0"
      "sha256-mRSymUEMqk3gLzkE3X/ZoANEKzGgUaZnvsEultRlMYg=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.19.0"
      "sha256-Q8lDArDHDpawqP2CdXtLlUlAggnaxNwgHM/B0WvQtZs=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.19.0"
      "sha256-ZqCCW2Bpw+mGOPTyyrSqwwJnEXH6jTaATSMUitePeVM=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.19.0"
      "sha256-YLVwj48FODPzwlDdnh4to53H9LA1ZIxJg38kYUsVLf0=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.19.0"
      "sha256-UEHk44bZJ0Q9ato6kXyL3+IxBoffHb849l0T2TMjmes=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.19.0"
      "sha256-ngeVKXi88soopT/6xW4o0/dHsXBF1Rsyn7dlU3RL7o8=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.19.0"
      "sha256-gk3yMsBrcy03SVXqlo/Ap/nLdeZ3TSbkwO+NWFf+xXo=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.19.0"
      "sha256-rQy6d7Um3BMNOdPiagc1BuTG8HIBK8Qv64+nn8hHcXk=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.19.0"
      "sha256-LhS/8C2yFtaSyhoKcbbrvEOC+RSvDGfdgaxH3RqqiSA=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.19.0"
      "sha256-5QTY3mdeLBxUdm6fv+GKhcpryj6OE2lpJncng9lvDfY=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.19.0"
      "sha256-1vct4+c6Lc2wT7wapjR3KJFvfYejMG+DfmCIDJumQ1M=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.19.0"
      "sha256-9kzHUqNM4eolcHzRgzappTp4BaNA6cG5Nb8MfZTDfBQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.19.0"
      "sha256-/fEBwBwox4cY6ktLsPx/+Adv4jen1DTLlH1/bmCLRrc=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.19.0"
      "sha256-9H//6HnS+fXy66X8OYANWbhPJFYyrBl4Cbdsg1JbpJc=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.19.0"
      "sha256-zF38+ubs668aVdAbHTy8jGig3lzjfzLPXltlHHEy4+c=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.19.0"
      "sha256-MXsxOks80tKQKce9gb3cGr95NW4h60nco73JCmYHnq8=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.19.0"
      "sha256-r89m/OK7NImlVj2jVnK29uaD5jeY26Pz05WHK/GxR2w=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.19.0"
      "sha256-Pcw8y8Y9rguaxh9hTFdiJe/vHtKUG/ztyLwkzKQrMls=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.19.0"
      "sha256-BKFviHhX+PX2lD6aRsTqSsy1upEa93NwDXKucbidTRA=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.19.0"
      "sha256-/06+MRRcp7y97JTZohZB9y5CQrz6mRWkho57LLNpK4k=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.19.0"
      "sha256-rMmxat47aXDLJYoGUuHSNU+B2zd3ErrwUht3ztiB7Fo=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.19.0"
      "sha256-pgElqDn9u3kNsJkEg9lpGW1UlyklVj+UBler0vG0U1Y=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.19.0"
      "sha256-FWT/pamWQkW7gWJ4ahGSnhO5SzgTYlX2rL5aPDqZa9c=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.19.0"
      "sha256-poLyfzAeKQ+qf7+kZrwYvs43VeFdgrKxbSFKISIDTRQ=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.19.0"
      "sha256-BQqqgoHCYtTmIJC38O5ziWyynldUhZUD1JK6wRWd1nQ=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.19.0"
      "sha256-i2ZHH/zqkyT8oVFpl+LHQ9wtK7GG/laNF0Vw+3/wEEI=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.19.0"
      "sha256-gWVYsvf7pnhi+a0sACaQ1AsNYpfZH0E1RAeGBNFQkkA=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.19.0"
      "sha256-ONj2j9xu74XMHpUllRqp5U37l/DEjXevQ6OviK3/Ul8=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.19.0"
      "sha256-4ouQEQPo81/ukvCcfngGbwMgUTrEw3Wm5mQzMrwnKyM=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.19.0"
      "sha256-gl7MW1+16Y7V990/nSqJV9TkL9DbMgleaqGGCOeAjk8=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.19.0"
      "sha256-7RxEXmqBRyIopT/JszQOG7nEazhkud5q+RqGmEkTIP4=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.19.0"
      "sha256-aB5ZUuujdRGOclrRGWawhuq2guBIw8bsLEhorN3gEms=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.19.0"
      "sha256-S4cfQiJiycidSpg5np/4nb0P/luHLWP2TybkRCuUDpU=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.19.0"
      "sha256-vYotT4l/czPiv5rT9iHPlH9UwjOxKIyUjG+1kLXInh0=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.19.0"
      "sha256-SEMB8lNbeT5ftJrVjXU/2APCo77U86Ms3jxl0aPWFcc=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.19.0"
      "sha256-9Ek05U0XjR8kO7C8/YpZIA6JVH3go3o42VRRn76OjtA=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.19.0"
      "sha256-31T4cQMSzx9KrqyobmMyZgQZWWW4E6eEU9I1a/tHW6M=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.19.0"
      "sha256-vCKcRF1l4nt4MxhG4XLTTiNkN0Fn9vDBwoUB6/yQqVk=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.19.0"
      "sha256-ZfBwNn/HcIOM5miGCcgqwjiZeJuzdpI7gWFNWAKda0A=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.19.0"
      "sha256-wsiPCb56d5TP0MfacKifCaGfjFH88VKUKpkgsa7hscA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.19.0"
      "sha256-SBJWeiVfJPMmF7ZEsdzvjhd2m+NfV2WQc3SUDehA+dQ=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.19.0"
      "sha256-tNIMUf14ol5VLVdFuUOLQwXHTb0Fx24KaEc8LoG0Dj8=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.19.0"
      "sha256-xr473yjoetogSedKgnhmsx83HkdmQgvNo63lgSkKCVc=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.19.0"
      "sha256-QlFUvYpXnV3YHUOOqB6LYZZ/m5LispwYvO5VTBaO/NY=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.19.0"
      "sha256-AU8T2GFRsr7np6kQnb0HrWMGiAEGw4xkZXDoEvGvrjs=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.19.0"
      "sha256-e+FCc/wzp2E55oLOcM4maudRm1aQOGERM1F/tMcso3s=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.19.0"
      "sha256-3A/FW+0ZIyXD4MLC/FP1nOgJUWb3n9B3eCNkhLSvG+g=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.19.0"
      "sha256-498RyfqpdP+7LixkAcpCTiZV89AetmXKGw/YqeGsqTY=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.19.0"
      "sha256-t2k2+opMikO/yThXK0pKDGiyw+uFzsEXxMMD0Vspgl4=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.19.0"
      "sha256-lue1HfymqxOVewRqQdappK84cmLz64N4NUY3o2EMHjg=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.19.0"
      "sha256-GegsX4SMxvOixLGxUFqM0WEWEQvqHk7uzhRnpL00M3I=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.19.0"
      "sha256-qWk1P6HqEWdDmjkJDtA2nGJN4VbjtJCt2wb2rYe8gB8=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.19.0"
      "sha256-Ew65vxnWDhm6JbQ4OhRQuM8i3bfLRINYTHoEgoXgmX4=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.19.0"
      "sha256-io3tN3ZaCQw/RjL3CLHWNkLaJYhe3UuZxsWEopBHXns=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.19.0"
      "sha256-nFdAo6+f7JMoyIVEUiIJ54f5B0qAb+sD85paK+C1syI=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.19.0"
      "sha256-vMT8ymJSa5VYgxQv5wwdLvI5jiVKCCngM9sqJxAm/js=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.19.0"
      "sha256-y/37i/AxqmCG+ngj04ZSod6awcp8VRb6YOj9BaPA2UA=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.19.0"
      "sha256-EqlhGHDX5cB/NIh3D/65hHkCw0CpGRouqdJSMHQbzZI=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.19.0"
      "sha256-aKHn0Q2N/IylAMgHaeILEtYom3rSuP2f2MDZqrvNyW0=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.19.0"
      "sha256-9mJRhzC/qahFAyXTm8J8gAgPtDY0pj1/2aZnOyJk9M0=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.19.0"
      "sha256-KCIEO17EiLu6FYznNx9mekzofmNODi1B7rbWvprl9yg=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.19.0"
      "sha256-G3GFmHrUhOoJQfXQdqKc90exsR4+4dgWc4CvNOMI9cg=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.19.0"
      "sha256-zO/qG5CaSFaqlNgZSze3iFRJ5TqflxEnRC/OQR4Xt7M=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.19.0"
      "sha256-tO+I0xNNrq/eL/XwEAENmiR39ipp98Nqd7253MV8cPw=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.19.0"
      "sha256-yRKDiP7uB7bZTRCHu7tE/FPDBByNFjCo95yVafPSx34=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.19.0"
      "sha256-+t909Aw9QDGW/DY7Ht97zKstjBmD36RNCfjtJUdkCUM=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.19.0"
      "sha256-eeqH12hNxR4oToOd9B8Bm/aXCZmo/7x8ANIs5qP3bYY=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.19.0"
      "sha256-KqZGrIHUkHXBfv7wJ2rWm9FdNqwVwjfF5DMFYh6XNLA=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.19.0"
      "sha256-KVg3rAkFU3r5zZ46K6UaEpNUGXYAnedYxTiJHdCz9kg=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.19.0"
      "sha256-DEUnhpfKsgd6MItoNgd2jMcC8xH9qYPB/QxqsDOlT8I=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.19.0"
      "sha256-bV/L3zknHT0+JAI7sXEsWDLsGciNxp+6ZuFlj1QzPss=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.19.0"
      "sha256-f69WjdfiRMns2WhBBC2WIk8VB73wul1lVRCQ6r+u5J0=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.19.0"
      "sha256-NLMvLzsxTQVhN7TcvCfkP310D96lhYkEcG9pi34xEsw=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.19.0"
      "sha256-FUmIsPY0JkmQemcrsW5BO2cGak9gUNmIhMkqoqETtkU=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.19.0"
      "sha256-wriAmM6u3Q+A0xu9K9lspJVWKoJ1meePlaCPSrt9r8s=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.19.0"
      "sha256-xO9zTFPbnoAHbRlC4AWr97v9KwfJ3yjVxCZQkkCIRfc=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.19.0"
      "sha256-EO3vnvtApiStTRbZib9YOKQW8tgOaHu1PwpOAiTr9aY=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.19.0"
      "sha256-fd87+JybQeBTlStn4kFbLPJZux9RFOPsdGmmbSelkgA=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.19.0"
      "sha256-phNPTcnP6t0Pm/wGDuvBCbqsWY942HQxeWMgFTnAcOs=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.19.0"
      "sha256-tgfpq9SJhbk6MDJv9WCMfmrp/+477tP3C79tL+Z0cI0=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.19.0"
      "sha256-eXAH/NMFlxOAD38EDIVEvAPthur66Hxwv+T7O6oZmSQ=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.19.0"
      "sha256-VeUUK53Z0wThetPHbG6av3Ywu1bKt14gneMqAL2VPNY=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.19.0"
      "sha256-NXdhxHhRkCDb7I01+VtQQPGklJMJO7RjLw1ieJHAFKw=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.19.0"
      "sha256-CrpoFDfl770on9fa5h2rCmopBp2whApNCSR/zYdpvuo=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.19.0"
      "sha256-saskNdEzjc7EZdfLxWy32z/lfz0C4h3Q8j0y+p0F3G4=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.19.0"
      "sha256-VZHZXMmQUVdvrxyUonRTaxPXgtWYr9eK43w/mBUJq9E=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.19.0"
      "sha256-s6L8AyC+apgAdwnVOGPohITamUE0wqgK84eiwnymmS8=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.19.0"
      "sha256-HfLYMDjpFDwOjUJLHpu4a/SKewJyXSIbHAs2EBZN/Yc=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.19.0"
      "sha256-6mvhcfp+Urz2vkENpd4zY9CtPXXdbTXtWY3nfAKEvGY=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.19.0"
      "sha256-udXviZdYPcZKnu2xk+Q3yKrPNzhUCihbEwIldTrW/Qo=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.19.0"
      "sha256-h1WcISJiwVTp+1VipxX5aEcHoKhVNdU5qEplPZV0DNI=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.19.0"
      "sha256-pNjiowU8pfl/e0akZw5iF+f7Wz7eP9RDH8YJFrWA+R8=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.19.0"
      "sha256-SEJD1Osgp6xq37UTrOhaqZyPW50PFMFeaocCda8jpic=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.19.0"
      "sha256-9p2JgiK22f/TJGahzajNvGeuyqLOoHVvvxzNUImDle0=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.19.0"
      "sha256-p9UyD7XoBQfXWK8HFFUVyVpExfkOqh7tKOd3xPs4QY8=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.19.0"
      "sha256-uwoXyTRKIida7oS/b5Hqlw/GxK5QA6fckZXe907jukk=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.19.0"
      "sha256-ihQh4VQWSqFHVuX+anU+BR/01D9ly9CWAaFD9j/CHP0=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.19.0"
      "sha256-T0MivOaHPxwbvmZxncshqG6s93A4eG1SWXUM3LW5L4Q=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.19.0"
      "sha256-qzASi2d8mOS4XqwmjKzXqUwbcatC3G40CB+TUIwOWrQ=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.19.0"
      "sha256-BPfLf+NosKej91r/j6FenLvQb1MusysyjHdI0Z7Lg9s=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.19.0"
      "sha256-vZ9WYwKDowBPuqTLOvrkh1MTIMEHKfjSQUInwElz5O4=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.19.0"
      "sha256-ykBvDD3kzvvwFJ4EQtyMpdvqxWoXdIkp6kdTwI+Ew98=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.19.0"
      "sha256-XkEXY21/tA8GiLkaXmYpeV+yPdLT8oaEIauSi90O/wA=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.19.0"
      "sha256-qlgraRkWHHRycWAW0jmIjCNOY7KvKIYIvF3r8D2nJ1Y=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.19.0"
      "sha256-dJjVc5T/SIFlWvH87R3fr3wOUK2s7UII7fCsUgOujNo=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.19.0"
      "sha256-wBgw8dm20+0XoJ+kvr1Too+eIR8VKuI8RazR/PWjmhU=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.19.0"
      "sha256-UuMU5/xJ8g/4OSeg4QeGnGYBTchYgnHC8+GZZP3oAYw=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.19.0"
      "sha256-pn7FSkul09mpd6k9guuZNAHLaD2wHrREK/rNJw7GxBo=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.19.0"
      "sha256-yRP3wCtSHgHcgYyvCgXdgipx2MiEpUYKcz9z1Lpim4U=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.19.0"
      "sha256-mad9ZE1Vstd8qowhbMCkRDgNrNecb5WJhWpv/TMR0b0=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.19.0"
      "sha256-is4nHPK2DM3RE40stn6FNgXK9+PHBGjB1u9cIORoFNg=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.19.0"
      "sha256-evaEqyyq09yqCvrn9ljYe6d85cnh47wo5OupZa0svRY=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.19.0"
      "sha256-v7GQnLk4vE2h5aK6Fm2fDqFV/0mWLk4x9dy7Ho7OV5w=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.19.0"
      "sha256-zsg4XawFEqABmZ3CyQW3fsLagd3kqKPN73L0sD3wM58=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.19.0"
      "sha256-6BKseg6X9K04242gtCisJbmZR9U9C8aBjCSetK05U1M=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.19.0"
      "sha256-6WHPm78U7kL6XDNGqfYgkasoi+dksYIdIV30mTsgzQo=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.19.0"
      "sha256-0gNKcF8OEzcU1xY+c4DGjVjrFwC9XeXrS32x5LUMDZ0=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.19.0"
      "sha256-AeY3FZIqG7eNNywuM+9XDf4VNAVyZNuQYQ9oQH8BLyE=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.19.0"
      "sha256-/JWl65l/tak9VhKSq0LLSbLjwIP2wuiwMiLfRE4woXY=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.19.0"
      "sha256-Yp1yJ7puTJsSJpvx+wA0MtFA4Bbj2f2nCpFqcmLreiI=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.19.0"
      "sha256-j8ufIdMGo2iXpaBqpgIGeRFEiuWT+l4bzI7Eg+CWfDQ=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.19.0"
      "sha256-dtH04iDzs639/2DeJNmgy7rNaGxjPm+Cq8lUfIFH6tk=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.19.0"
      "sha256-gQyOeiucsrN9ggz9itoKh6/W/zwp/1oI5ezmxcuftDo=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.19.0"
      "sha256-4za4LfGbvFwPvp+R85fW0KdaRHckGrS1vNWXMKBQI8Y=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.19.0"
      "sha256-iFZhMAYxXCmy7Xn9fyz1vGknzmuWQL3KaM6hJjrOYS4=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.19.0"
      "sha256-nRS13bJLSpou1y5n8XIAVqYdg6pUy0ffzaHbmPrgBGs=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.19.0"
      "sha256-2TAQChCC1qFxXeIb8/CJGmTa7Jan40dfEMRRV6FHFrw=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.19.0"
      "sha256-Yi6WPluoDPgr/KozLlaB6IONZsPKXFTrJ86MIqyWPCU=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.19.0"
      "sha256-ItZp7NUosz6TAuEVZoJMeNUxnyG1oo0emjZvHETGr5c=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.19.0"
      "sha256-yFp/ScNianc4S8D71+TLM/vRluQBnBjNy1Zl6l5LXds=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.19.0"
      "sha256-XF0MWeG+rKTlLJHQfvTT5bmeNxi5++/oj1EyJkKcsCg=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.19.0"
      "sha256-Uhj+5WIMvgEcUF7kretbaUCmHYf72/hKjDuR3zBue+I=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.19.0"
      "sha256-v7bf6+K8kzHk4B1r96SCaAGzOMKsYKu+YCsxS3n5Gng=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.19.0"
      "sha256-M/aHV2FizlN8JwtLs7fh3Y+jnmlhUtHnIXlvcAhQTUM=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.19.0"
      "sha256-Pce8bN8bWcgLWtiQvxenJf8hIJH2Ct9/MAWWaslqYa0=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.19.0"
      "sha256-q7YzE1hENc8cJmEkPnw+7sRfJs841rRA/rzMw0o2PXs=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.19.0"
      "sha256-SVmUAR/xS8Sff92rm5Lq6JP1N7eQqKgs+AKJ7HDli9g=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.19.0"
      "sha256-dnNiJtUoB2zniHbNmlLbdc9GnWa3fTc8vqQMlsR7vvE=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.19.0"
      "sha256-Sl98oMUu+V4/UI5StIhPKPfZb3IDblWmAoLHrFWSU+E=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.19.0"
      "sha256-sp/pc85+Jk96xGf0E0gNrGXZO2sSGQB4w7VwG+zVwU0=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.19.0"
      "sha256-yE8WzNsAXNyiw2gN9pLsBxQxX/HlRD1l3Ho8JIQkcaw=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.19.0"
      "sha256-xmYa9OBnARbW56ypoMIDMXdE5cQ1dEmyxZBbDFM/d/4=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.19.0"
      "sha256-+9hw6MdiUg1ZATN8v3DXyDyU5PqWdfWJj9JPBdtKhJo=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.19.0"
      "sha256-5yckrw3mS8kh69N2JBGzBnQO/FzHBvTVsw8yvZx8Z+I=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.19.0"
      "sha256-0Qf2Bv9ByQg79sO8LCW+q3jt3FQJ+r+79yUYRpfW7TM=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.19.0"
      "sha256-2CPTyyeoJ/9RD0BYcIBmQIvc2hFJ+4JFmBlHfRCxddY=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.19.0"
      "sha256-9XkEpm9+a0/ivgbfnac2j3+fBJzVsNpoYjh8mnBiGNk=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.19.0"
      "sha256-6AbeJWFvfDL6BbxhtIHYHxn/AnSDC40h3PKBFD/ObDY=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.19.0"
      "sha256-A3WZxCGT8ZprJkZHE5rxyTK4KfqoFMfeQ60ZaoE4Oms=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.19.0"
      "sha256-6u6wwTci05kHbJMSqKLlTWu8Vhi8nuiIw94eTIWdtL0=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.19.0"
      "sha256-tk2bDNN2ryRHed0dAcZW87il/QhmH8GhHKrhfTzYM3g=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.19.0"
      "sha256-IHXxwdjT4GbP79MFdufsuTjeqUHxZp2onyhCxEDmxHM=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.19.0"
      "sha256-dKBcmOCqNVrgL8CCzOapOA5gFZlGSGnAO3dMtH4TGD0=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.19.0"
      "sha256-l1D9e9zhrqxWNvyOqeohiubYs7/cZOp1LASQto+mUjQ=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.19.0"
      "sha256-yZphxSNjHV4n/OF8XjApClttUxbXHNFNoifo5H+3J6o=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.19.0"
      "sha256-OBXi2qm6wgddmrIp57nSTm/2z2yVTWSaRw0nffqsgog=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.19.0"
      "sha256-HEpw1owl7PXd5WrbrHBPLvLIm1JA3alExnYPfSeMpNE=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.19.0"
      "sha256-qnebBxuDeS9UJVrLtFRxrfqzxsxDAVbw64O8RQYZsSQ=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.19.0"
      "sha256-D3PdEikcFuSwOcz2Dco9GIlj2M2reEtHCzTF+IA4NzA=";
}
