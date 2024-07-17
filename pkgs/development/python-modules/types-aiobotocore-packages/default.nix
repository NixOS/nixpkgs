{
  lib,
  stdenv,
  aiobotocore,
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
    buildTypesAiobotocorePackage "accessanalyzer" "2.13.1"
      "sha256-Uaet2w0Re7mCVBJhbjxMv6dvBj96VfKTl5XTAG1WoaY=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.13.1"
      "sha256-eOfLc045Qvn5lz36My+v1vNAvQkPzSfabaVxIBC+kok=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.13.1"
      "sha256-+X87aqLD7+COapS6//oMv+lLxjs6ULQptAXW7FYSgcE=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.13.1"
      "sha256-vc/stXsbP5/HF4SpDZoxNJ11prW2Dg38s7v3sxWHOMg=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.13.1"
      "sha256-KybFUBaKKGfZJmJ/hdu3M7evD8yD1cwZS1AUPsy+kX4=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.13.1"
      "sha256-a9p6mO8N+jbuifKbeshURjlVDENL1m1XzZE7pI6OPQU=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.13.1"
      "sha256-PysfMHgo+GsSi+fK6jyk90wNVX4ItZwg1clES+ShzAM=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.13.1"
      "sha256-tNOZIhKR8QkDBbD9baqRHqoRCJAdRJPjkW0FVj8/k0M=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.13.1"
      "sha256-SEU6Qw0LCpYKvlnjh4XZXGogmXilbLVuN/eYEt18aO0=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.13.1"
      "sha256-zUgJ0eOJkzcu0y7zcrfHwhar0wdon7antjzy0HeJuQU=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.13.1"
      "sha256-+8A7eXo01Z2EAaps1fFFiWWvNdO+DpTM8PV0n2whpvg=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.13.1"
      "sha256-uhhxVP+Og+FiOoko8gjdUavhTP4o+wwrXm834wc4Lac=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.13.1"
      "sha256-xCrDWBX8jR2851rMALz7itYxffvnah6yOq8S6UO4NvE=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.13.1"
      "sha256-oz8iPiF6L2aITqmDraIZ4vMJTHMEFfNF9gDMj21vggE=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.13.1"
      "sha256-1rlhU3wAGvl1XSE+wkulJdyeV93en4VvnjpnaB12gi8=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.13.1"
      "sha256-DB7kuMeIW9XStOSw2h9jsQPfAiwK94m7xbdOoy6cpPw=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.13.1"
      "sha256-aJaPxZXm4lBh4EDsiC7HauXmS+GNzhtQXPTF73mDHw8=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.13.1"
      "sha256-tZj8H/seTnIxtTybQhJ8u5p9Roiq0mbxuX/k6OriZOI=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.13.1"
      "sha256-QYyROZOiHB40gRKjQnRcwQWGAX44zbwPPamfdGrpvhU=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.13.1"
      "sha256-o+pcPaWXhZsVadQzDWQi/8+IHY44Sk4z7ckzGO9rPtE=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.13.1"
      "sha256-EOv5cWNlnQkmg5iJNliw/PXBGwYdriOnuUAOpvE+QiE=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.13.1"
      "sha256-WD7ddhaEp6cs9wswWYvyABEVwvvn8dNGmjcQhRfOG7I=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.13.1"
      "sha256-azWY8AV3qVs70WKd8/izDCbyddAZaa+AJoWKZhOcX70=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.13.1"
      "sha256-auQRpYcMG/DQXNWCu4KFKqMomo2MeQENeDFvpBC864Q=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.13.1"
      "sha256-7caEszKVxK7pyoyqDr0kkT7rtekljZ/+E6svg99pL1E=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.13.1"
      "sha256-bNfXtBabYFgNdWu6F4tmmgHBvM5xRHpruDTPVIX10WU=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.13.1"
      "sha256-yOKRClE2ziH7YraQ/RDKuJosPmFbk6l2VyY/VNKzyPI=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.13.1"
      "sha256-Pq9A+24LbD/izfWjv2my7RZRmuEoEkpYnqKsJUTGVIc=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.13.1"
      "sha256-fAoxWR8TV+8boe1XHt+dhSK0e+1RDc4MEy+Wn7DZcPk=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.13.1"
      "sha256-UU3C5zdJG3OXpevSnLnWiPIQR/0ear0IC7pBvRw6SJo=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.13.1"
      "sha256-7K1ifpUy/tnVyOn5cT0Bpqp01LL3mFlJQjxb5BAiR28=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.13.1"
      "sha256-jIddm3hMFtQ2/LYEpHCSnTUq/DfBco7TzFUN9VeO/lw=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.13.1"
      "sha256-4icZ+SDl/c3Cnzikw+FDuNO14QxihzqcXTaGd89SOQ8=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.13.1"
      "sha256-57X0EZ8KLu3A2RYSZDEhqltgWtMEH4Hr8gXTbIAXUrY=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.13.1"
      "sha256-518KyYlsHBtAimVhM6ADzQkCKZ2hMtS4sKXQZjrSZ/A=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.13.1"
      "sha256-5KtJXVleXuSVrRMb9Dc/dcIuMRlx1R2dkH8uOA8kebQ=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.13.1"
      "sha256-lGKZbWAXwEutqjkj9kV/88VqZMjDpIXeuye20E7quPY=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.13.1"
      "sha256-nZhgUByQ/2hmY77PPPICSiOpSg5pabOFCfxUq374wqw=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.13.1"
      "sha256-KNZ79bAJQemRhR65c/Zruh8SRubdHcPfVeqwsf5y/vg=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.13.1"
      "sha256-SYvTxDOoqoje4fp0V7CMMKns7PNaGF2uEuXTbhIPHFY=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.13.1"
      "sha256-CZmTJGl9IXnYnlKsnq49o7TOHjFYQXf7g7H6dQ98Clg=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.13.1"
      "sha256-0sxIwTUs2usAhuJ0sghw1QUDKu87pwx1zKOUdDvPCXM=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.13.1"
      "sha256-4JNR2drXNI2sJ1JXkk5NQgwK1CeAxrpxTHvSbdcX7Ds=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.13.1"
      "sha256-CHdqWRL1ZIJCQ65Dts87w6IFlU4ZpRD9GSvXah78Kow=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.13.1"
      "sha256-2oXpXFuO3jJ+lvFsjuAh3pw2lhfnuRLGtIcUep4QwJw=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.13.1"
      "sha256-M4D5z53xl8hX4q4/Co5UJIUw9JxbxTQf7hhQp/FpVA0=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.13.1"
      "sha256-GQrg1dPD0HgIe04znp1rajEd/Fmp7B/rP06lsLQ8uV0=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.13.1"
      "sha256-ASmEjSNYbZ1CANSSNw2Fi7ieKVE42WNDISpqTjBOVM4=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.13.1"
      "sha256-154gs9XMFcz2urECTUwyeZK3iafwK2OYaCKaCMjCZf8=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.13.1"
      "sha256-QCm7i0wXtPBG5pT9V0WA9SCWjcT9bPDU2T2alCNfZEI=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.13.1"
      "sha256-V39w95ufoIbbDWUIPiVtdqZPTiaosV+cMBXKljbuEWY=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.13.1"
      "sha256-BB7gmQoj30OZ2PqEzwzz8XwZuuJsLRJAXETzkP/nTzg=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.13.1"
      "sha256-FwnZNsSIHD5pLYJepyP5Vde7nd/TFNPMCEcKLsKZv28=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.13.1"
      "sha256-hgn4kDF2hEasQG2JjvQ8alzWEhfHeFvfk4mTOCHLfvs=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.13.1"
      "sha256-CE4aG69icMYwW/y+IpBhN1Vtkt+yIaQuIPCiZ0lnV58=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.13.1"
      "sha256-HLKQS+IaiJsVQpgGKocHgHFews+br3qogOHw+fhGbJA=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.13.1"
      "sha256-EYP61ycy0paJ/Q6H7b67aRvEvqam3q4wAtbLlG/+2zc=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.13.1"
      "sha256-yFKsTfVAe6lN9WFzHRtmCuuNElQzC1LkMnvgLFayDwM=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.13.1"
      "sha256-8W/45jb4kJhaIIr9SoSDkhsl9FLZtsijaxsPjuk7tno=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.13.1"
      "sha256-5Uz2Cfxg1GMsoYS5i337jVcXXrZYPZEhHt7KM2OlTrA=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.13.1"
      "sha256-u6h54g4yHE6rVfi7t9q8RtRZWPgEGqGOIOphOAwq/MU=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.13.1"
      "sha256-Ryj6wcXqRcT5qXQIvD2foKz+5HuH0VT2K3hvzoc6tx0=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.13.1"
      "sha256-CoU0OEGz2DuFLeNqCWWj8oE2MoSSdXyKB+NT3Pt942A=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.1"
      "sha256-bbn+UQa3FTVDSh9MkkSIzjXrJ5VRE2Cey0qsy8ayKKo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.13.1"
      "sha256-IlKwnmjBJGg4/t/nsmNU3SHg9Bt/xUTlPHEyDyDHPP8=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.13.1"
      "sha256-A50/E6erKSQWHjAJ9CpRIz5/waUwO4yqagdVULraO9o=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.13.1"
      "sha256-GXDC1bJbPy6wWrHWQMOlMR7x9hGhO9jzWv/8JXkPyGk=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.13.1"
      "sha256-vlKEPVh/5By2I7McROQdNa8XlF3Q6nrA/pgIeDWUPgg=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.13.1"
      "sha256-lFEn4TQ8ESrm0HAb+YMYiEqaZAqkX1kZLLn7hbSzAQc=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.13.1"
      "sha256-F2t0c8J+h2o5fZlAwRGtF9UmHyYilrrncRkTIMA5mC4=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.13.1"
      "sha256-nkjUjOLIuYC95pltFInfXDrvM4SckHf7+iJSQC2WQ1k=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.13.1"
      "sha256-p/49yh4DHMWyetWVyLh1vqOnpWxKfQaP26UNOzQJ/U0=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.13.1"
      "sha256-JXg+fCdaGBJ++phhSjUz9tFtZTH2L8RwlGbkE00b/WE=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.13.1"
      "sha256-8eI2xD1RcI7djPKdCL1vevnFUSZPuHYEsOdqiVM0cfA=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.13.1"
      "sha256-n8vtERLR98IyPF7jOBdzkEz+Jf+A234MbORfcVN0wRw=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.13.1"
      "sha256-QSOX1MYrg+L1ESOEzE296Ne8d5F3aaKztiBlxJtsAiE=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.13.1"
      "sha256-4EdnxtOLZDryEUaMulCkenje8zSt8mujs0QPvl7MhpA=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.13.1"
      "sha256-6iMw+gk9HIPv6l7j6lwSKmQPeHs07bhEL7eY5TnIEJk=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.13.1"
      "sha256-vPCIltZMsBBEqHCKh5BQ9ZuwZrjqzhUIpLfS1KGCtz4=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.13.1"
      "sha256-PPFJQ2Hh3KCTTe6dGAyuTNjYSQ8s42lvf4/ZIhLxVnk=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.13.1"
      "sha256-qckqfZP20Rlg/MiZUsFV+mBmrbRNob5jm655l2Osons=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.13.1"
      "sha256-qmh7lRfGBt6YsyC08BDAFyPsJ/h4JqCqUNup5Fmymbg=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.13.1"
      "sha256-A+FeXDt+0noA2GwfHYiq7qyZ1/qYS+WlIn/ZmJvkPPs=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.13.1"
      "sha256-5IEPIDBzw3BnFjMpuBhPxjPwcWoKBEhGcYIv7BFHzjk=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.13.1"
      "sha256-PBThgOkESfmfCgehLRboigoPNgB1ncQy+pTArVwyNNQ=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.13.1"
      "sha256-XnENL/AXDPbiYHoP4q5dIPnZjntzEps4Z7+Zz0idGGc=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.13.1"
      "sha256-HPG0D8TOQDotnHwL6PsG4mpB2IgBA9mlC5sWQPwy9iQ=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.13.1"
      "sha256-e2RQBZS4cXWEKtN6cQdUG/lSyP7J+alzfNlZ/8hYKUc=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.13.1"
      "sha256-zWl43w6QWSzXnBcoCuvQFv33TbgcQrPZ1A/YdturwVk=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.13.1"
      "sha256-1pSPSX7Agzst4aTALLE0ZCyMZVrdnI43GQIjrO95b7E=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.13.1"
      "sha256-8AL6/4Hc0e6Ew+IttkS+TH/elbNk7kAEVrlEykdiYZU=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.13.1"
      "sha256-2CyerhSqGOrXVvPVBe0f1Z/EzZVwWXHtskTAQHX9iDE=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.13.1"
      "sha256-u2fQo8rxuAwME7tBm16HrSUy+WXS/Pd9HW/MEMZ+Tc4=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.13.1"
      "sha256-tuBnHhnTRo/3qp8ZVSOsgZA8uY/9ZAKhu5GTcxGSbas=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.13.1"
      "sha256-DEFQP9zCXZaol/CIw1DYfFcIq2eia8dFxFA2wXdt3oI=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.13.1"
      "sha256-ZElJBbRMRxIbpEGGfukE3960MoeprT2Cutf72657KJ0=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.13.1"
      "sha256-0+zSG+xITYFMddqkeFLPTD3nKdZhJXRbIgqbWQ9COB0=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.13.1"
      "sha256-YJxyiLgbryyzCOpWUdpw28uSALB4+aNPX4kc7kq5LHA=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.13.1"
      "sha256-L2MY8Bg84pACtheQqvx5ifZE8Vk/BPP0WV9phEJkzYQ=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.13.1"
      "sha256-sFwvDd2fIsK/86xxpJ+V3WyIQQTpCLzJL5U01ecliSk=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.13.1"
      "sha256-2UZIX3qB+1+zmI2MNNvWuW0W8J7ALTn6L2HulWJkNbE=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.13.1"
      "sha256-1JfthjzoPg7AKiJ8+IDeub+z2h6jc8PSELzbSsZPJ+s=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.13.1"
      "sha256-M7SBFTH0R0pR/DNspYLVJT3ZjEIakkqcCVxt0by8GPI=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.13.1"
      "sha256-5xDlfYf5sVngVkz7cUlBVp3mZgyy7Ir9NTI9OABaAg4=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.13.1"
      "sha256-/Agvt1KPHs4tlvUPIsv3WkSISYzTf5MDF2W2p4K4ix0=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.13.1"
      "sha256-lZip3L9g49AhZDfiLMI6Sub4tareaGK21M3x/8SL0Ds=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.13.1"
      "sha256-jcLVLCcwX2rZX6rkFXK/WnrFY24DP4cs1KOS4/SatdU=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.13.1"
      "sha256-fpf+83EIrfw0b8eRVPzv8Jso2rig/YwNvwnV1BXUTjU=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.13.1"
      "sha256-YJDj31GBbfqvMzQieBbiqroi1c7XY+ls5WLioDopfxs=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.13.1"
      "sha256-QQftlSV3/ecfKJ+XLnh28dfQksqKSu6GL07YfnEeLjM=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.13.1"
      "sha256-L1Dvy5scS/PP3YWQ/Z8N/YjqeEennSbIGwxUNFwLYAM=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.13.1"
      "sha256-/vVRG4ss0RWlPk7fuSfITmFcXvRRGeRt4BDQlQudRgM=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.13.1"
      "sha256-YBnWgaK55Jo1IoQRziUoY7IIcVHjwXXlBQ5HmvEXwpw=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.13.1"
      "sha256-6vuMBCR5cd8H7VXvPZpTyxPex9/71PfE2aVmZSRPVxw=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.13.1"
      "sha256-oiAWpmJBs/kvNdKXnHqvWpY3DnX31r3QvW2JzOXXZVg=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.13.1"
      "sha256-+nuAIs7l6xVSGcMg01AdohUqTkU4vSWbU+8hZ+jT5PI=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.13.1"
      "sha256-zgMGXC6b2ooZhZFdaQDnf/Nx5IJAsqTW6egXMRtO4qg=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.13.1"
      "sha256-xjWWFmGM03NGlOKlOo0v7L8lVy03q3P8wBhLYEKa7xs=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.13.1"
      "sha256-Pvsd2abp28BF7V+2IOJgNlxHLiXy/3rDxNQ0S6aowCU=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.13.1"
      "sha256-6icdeO3oML5yEkfbA6Oaao+bX3scvXhTqefVO9SpBBo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.13.1"
      "sha256-Ee30GzLvU5oERCCJEzzxNHim4Dy1kA0UZ1GJBvBWLZc=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.13.1"
      "sha256-1e7WBzT7N9q0zq2xBihunaUUPgg5LE/krn3rRnB4gLw=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.13.1"
      "sha256-Tso0OK3RVPr3MEalyLKZlnBPAA3W1dIE26ZOxSV4uRs=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.13.1"
      "sha256-XL0LHEP21vqplbAe8YnakAFM47LCp8D+uXnlzUxG+DY=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.13.1"
      "sha256-VfwYpj2KVH6P1ELW1YTHlfms4pNdFsbJ/cPch5ygM7I=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.13.1"
      "sha256-jn2O34ZHKZXzoTSreNfPUn8hdY4OR8JYmK3bbkh7Gjk=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.13.1"
      "sha256-ZBup38Uw4U9d7QbLgAfxortKEIUq3TJbevgJIya77fk=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.13.1"
      "sha256-xSR3m24DmGDvaq7aCYcmM5ZYktoNDaTYIat0N1qICD4=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.13.1"
      "sha256-YIZ3hBCtHtT0S9DUC0nMTUv6CIf+zeBhcCwaR1AOfvM=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.13.1"
      "sha256-V1G7mp/+nvF5bA/E6yGby1lykK/G7O9Q1cPbEuyJQ+8=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.13.1"
      "sha256-hEwuAdbhYop3DmUQQFSrFG1pgqGVqFWp+LGutURhPao=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.13.1"
      "sha256-eId3UX9+TGCRGXfQKQl0nFdhtsKex6G4t8FWstwi+c0=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.13.1"
      "sha256-sCQiehUAJHXQ5gaSrR4Cly3X4xYelficyLvdudBFVmg=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.13.1"
      "sha256-TAUw1rS+xXf6CDJ1tZBoBQ+0QF3va81ZKr9kAfZCi1g=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.13.1"
      "sha256-CNPpXxrRN83LzxrsGpzdevytWDR/fpCADkRo59SNMQ8=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.13.1"
      "sha256-WI+Jt+83JB3khjm1gix094Sapxbs+yNKIRhgRs6L+pk=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.13.1"
      "sha256-7wDtgajzXuJx2Ydpfvi7SWyr3bR5jw20mnadkyienfA=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.13.1"
      "sha256-e35CQoyx1e5wSd5A5W4pAWK8WmbAftJqTpMcmijUShw=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.13.1"
      "sha256-DAMRdMfG+Ry8PkiECiJCwIXUbjTXWGZ6EfgxPI6BRfo=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.13.1"
      "sha256-m1LqsoGlWh7Hga+l/uZ3OZa6NK9yd00BviT0VDfuue4=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.13.1"
      "sha256-g9Tkt2rOIg9Y9RwlTh80eiX2BEj4TqhGNWWMKomFEKU=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.13.1"
      "sha256-SslzL8/NmeF4nHNO/7BGHle/brlzc/V4D+ssqfcZNFo=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.13.1"
      "sha256-GgkFg7I/a5wa03SlZtxYV2aGolNgzoB7TZrQkp7rjYI=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.13.1"
      "sha256-ovXUrl03Mut4QJZeItbxbtiuTDt3beGv0SjUBxZLyrs=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.13.1"
      "sha256-imFheQxmne5h9hN6yQOlSLWRDjdEYAW2enHhbTv+ei0=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.13.1"
      "sha256-N/xZO2FneEYp7Ux5OIM9XXHEyiZGfA5pDogPB7R8Les=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.13.1"
      "sha256-vEDQ6b8yf6yopj0cce1LIKR53ipmbAx5T/BI47shgEQ=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.13.1"
      "sha256-osgn2jHhrm9TiecS+jPV7VQW80ci8klwS85yFf4U6ik=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.13.1"
      "sha256-WLlWLxNPIOi+f2lsL/aM7TMfHsW+nCP+kDv8irqKlK0=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.13.1"
      "sha256-O5Qi0KLLqwZhK45Uzt3ufoS2sIuNaB/0gKR9y+KjEEU=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.13.1"
      "sha256-56U6mEIPQxNaBbml+3efOg0Bcoy0aTe6wlYGVg/Rkjk=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.13.1"
      "sha256-jkU6nulurbaTVshG1RCdvYFB23kQNn8VJhuuvLrpI8M=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.13.1"
      "sha256-3m6Naodc/JUxmSIVO3St6DVvBGMNQmelz7UW7xw7g5w=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.13.1"
      "sha256-HScTcygNmLUZIaj+jBp0gbPHEyhvpWC3l5KrON7+yNQ=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.13.1"
      "sha256-f3GMaGbe8iaz9oBX3A9GVCeyDztAl/Z8FFUqNlt60K8=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.13.1"
      "sha256-5gf8jxI3g2aB6Nq+6qZELrFc3S0yyxswnAP7lDERSvs=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.13.1"
      "sha256-ioxTcKwSmYOuLykUwiRwFkOUim5TWqL8aD4KCMONHkI=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.13.1"
      "sha256-R04IXZingyp/1DDL30QOhNjnbfoLIj4+GLkzWoCquqQ=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.13.1"
      "sha256-q2zWTqraceZkg8kPVptFBmK2xuVvhFbx6EEpqcuWi7I=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.13.1"
      "sha256-r8ye5bXfJjggdS2CSAzB1MTxUqW3WYnRhgyty1zUt8E=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.13.1"
      "sha256-DUyf0i1vj8/YKZEvpeI28Cxaa4m9jz9LNKIxM8mLFvQ=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.13.1"
      "sha256-apD3UPBHiyMDEbf3y1L5tENdWEfum8LvCNc5dIq7tvc=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.13.1"
      "sha256-Z133nUtghZZJNhSJdn1kwCyoerN+sANlikrse2Up0Mo=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.13.1"
      "sha256-/xTDdUOgKRBROTAWa/Yo1to7fEDXDzeidbljgFe1QQo=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.13.1"
      "sha256-rnGISy6NHILsoihnWVOAt9ESTcOTeBHt2VD/mlgwWXc=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.13.1"
      "sha256-9xCBsQGk8LKSl3sbZ+wgbzWICNfZM6rPcTrVBZ6qEjM=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.13.1"
      "sha256-xksZ5c/RNGUQkaLjchkngrsNFrS4MPcLp6t6RUkyeTo=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.13.1"
      "sha256-YXWl72Ai1/RMXtHIjyNgrq14Kar64OcZumCzotqI0Oo=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.13.1"
      "sha256-6SHFiSXNJGeq2FdvSW/G8adYO3CGw/IBH5Q0TLWCvfI=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.13.1"
      "sha256-+OhqW5cU8bu5bYf6u4hcilZYfUrxaVwJCSY77MrkPXU=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.13.1"
      "sha256-OYXYg9JF3cwJFvWVkvrWNSJN1VYpqBAlzxCBvNW4Z1I=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.13.1"
      "sha256-JhGNdHtkiPvMht53v6n7wNR8/bry/zoDoqqzygMyo4g=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.13.1"
      "sha256-uE/3/iBMMIk2qSjLcZ9Jv26Tfpr83p12jNnZme7gWLU=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.13.1"
      "sha256-e1zl7BksbzYyhrNz3y+b+6g/iPmeUZkj4lgJjWFIyQY=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.13.1"
      "sha256-2+B07qNWd1UXfVa7yeV31mBQ8d9L/5arYWTNjMaYfpQ=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.13.1"
      "sha256-f4ZEhcEKLz9tXnZ5jY2YlbBejX6H80be3GPIRbx4XxE=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.13.1"
      "sha256-hHR/i8xW0Qy+IG3grNl7cyzBJDfXCcAzUaOEP1wF3G0=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.13.1"
      "sha256-csqNXzwvVd0nMKA+52gVLt/PGik94ObuCxUrCWUfAAQ=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.13.1"
      "sha256-O129CbGxMDABLOQca2Xb4tK76+Xm/ZdfLASp42kT/JE=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.13.1"
      "sha256-WXaLZBIbash+K+F1RaSUGU1WnEg58DON2dgzsgUpZ0Y=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.13.1"
      "sha256-0951Vo8Y8hRrgveEGigll6mfG7YYSpNSXBPfzgS/4o0=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.13.1"
      "sha256-7B6cg/p00awvo8rN0NKh+A1vbBer6TTAYNjIFYQAW10=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.13.1"
      "sha256-mcJOptD3eqAg+C2Ghgemd6juQCklxAmeiELstnubF4g=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.13.1"
      "sha256-4j0rWpj8fE+MOZ0s6kB9KTQ2KIeWBXrxfmnY8qkKXtw=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.13.1"
      "sha256-mHRxhIYfxjSSEFc3AHF/wcJHt3CAEqlfH6dJC/NWLnA=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.13.1"
      "sha256-QfTy63MBeZpwVNOowmy9VmkMEkpy9ZVyIHyifyDTmiU=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.13.1"
      "sha256-S23klxiPDQkyCy4xMzxh0exywft91qwkAxDit/vUb2Y=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.13.1"
      "sha256-u2O+8yfE8goI29SUJ1lKTJ8h5KNmVFAb0Iob9RF1ZmQ=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.13.1"
      "sha256-Zet0z6TYa7VPEJd8f6fOkI44hC8Ia6h3gsQ/CLokBy4=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.13.1"
      "sha256-RozP6XcqZnOuSWlSK4C9tLm74OnzBe8n9f9mrXHQhX0=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.13.1"
      "sha256-skC7EDojgvq38MIZLBwFnMCEPcnYs3bB8nEN2Ca0Toc=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.13.1"
      "sha256-GRK5GRJBX9jn7hiXrBxTH3cyByDbfoW7Q+SxBi1tsPg=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.13.1"
      "sha256-dokSUVIcQAXkiPjB8cL4/HNW0vwh6Qz+npRzvELA0fc=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.13.1"
      "sha256-/CWGYa+qwyI9ULV7uAM8FXJOnP/pdiHQK1A+C2se1gw=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.13.1"
      "sha256-r5VzRqV7QHygTvRNb3Hfucr1V97U6k77SWYpz4hbSaw=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.13.1"
      "sha256-rM8R5/foSrAn6tg/mKSI33fRuZHcvvZE4gReNgMUdxo=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.13.1"
      "sha256-DphFsB4gD/drCtzonYMi00Uf6xZDxnZMwrPe3NhghOQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.13.1"
      "sha256-biycbIuk14p+Ith65PIqsYjjXsJJfKu3zpmSE+OzYWo=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.13.1"
      "sha256-Y0f3zLBsmV4q1CHr3EnFJEfonvl/rxlSiJv6KZRE5Io=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.13.1"
      "sha256-eafaAWDhDSUnw/JmvlHi0h8Ozm5ZHx23cKmwLQgbouU=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.13.1"
      "sha256-11WiQ99Eel1MZtnjQgmifvsq7teJPqhyJxC979W+Ttg=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.13.1"
      "sha256-LjDaNH9w+pyWsMPqa2GbRIs1kbAhNbNeFR6bOnFrSlw=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.13.1"
      "sha256-kIl2+04Iev+BLFrW0HsvQFac2qB6u/hTlkT+To65bl4=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.13.1"
      "sha256-Aou0aqeTNsykokkuUGn8KJ+5+pIqcTFHnCc4yNbLsiU=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.13.1"
      "sha256-CGKpFDh5+MXhGF8yfZlsUDOW1bLnQ4E6W/PyAexYtF8=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.13.1"
      "sha256-dhicdKLUuAFUHNihBeyME4Im1rtaAn/jECoA0Vartj8=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.13.1"
      "sha256-7ho2qJjBNWqcJ2qdvTCFUbc2R8CZRuzjyH7tkHv8ZlI=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.13.1"
      "sha256-O5Gk5Ok0wWHYsP/6IrPL/8tkh1teCDmBoeph4eYOpnw=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.13.1"
      "sha256-ik87A7P4Oro/Fy/gz/KQJsPubsun9ZMlEP5Y/xHGM2w=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.13.1"
      "sha256-v1JAKOy99C2H7k2vkE3SdM/BRjoBpEm0pHRSoxwyGKM=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.13.1"
      "sha256-7HAibOEHV2DOsLNmd5sjXePOnGiX7sQClwiD1IMAS5Q=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.13.1"
      "sha256-Ymg6jpoBQDcy/VEaLEluYII/817DcK69uii9EHmjX1A=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.13.1"
      "sha256-OzNc5eyipNPA0TFajfpXFa6kXj7tNupoe7p2EeDFygM=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.13.1"
      "sha256-GvcEWHpCR0J1ftCbH4rK3JJcG5KtRtvTm5YSEEn6gjg=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.13.1"
      "sha256-TNg2yvdEcBSJ9U1nsc+ihWodc//IPdOJ9miMZDYC05U=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.13.1"
      "sha256-t5owrAOVv4cMsUKbrT/QDd66pdz3LrWm0DcJ0g/fxVo=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.13.1"
      "sha256-xsAWfONvXq6x0BHSQkH+L2ikANbsq8+RNWV4iPhq94Y=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.13.1"
      "sha256-PDpmWUxroS2y8Kh3aasITL4w+7XGcwEZ3nJL+ffCRKQ=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.13.1"
      "sha256-pdT8i6eGekkTPAa87cibkSyjw6KyI482jOhkfFqiyRs=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.13.1"
      "sha256-AA25qAEWLaQBQ+1hJKoRrGax4f23CGSGoMpvdaym2xo=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.13.1"
      "sha256-CEqR0phDFZUtMH+JJqjbxLwHIC8ReiFTYG9MKFZajbE=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.1"
      "sha256-OBWSp6n3xpuAdWEP1DB+LoSd/Ds6tWSzMgC0fIYepPs=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.13.1"
      "sha256-xv2s3Ek2KvWUzDrOPWOpXC/kLC+VGhzQBihimhFZelY=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.13.1"
      "sha256-a1f/szq1zAskaf+28hpcxz9d5S5mYteZUo9TksnTAok=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.13.1"
      "sha256-vUQSThUV6hGv4gsNMp+HC0thbxGf9j7XjWECUULJYT4=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.13.1"
      "sha256-du5vrwZMa/1UkKImJ2AM1FYAsdZlvmHwB+jWvf9IPHA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.13.1"
      "sha256-NZT7U3kF9He4+MhlKU/CDzt0Q6wW2dBIsGqXqQ1ne0o=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.13.1"
      "sha256-xxcaP5s5vDReUEVQxis/4Kz+7e8UPXt0Mp4Uu9yLVXA=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.13.1"
      "sha256-uLVJekBSmrJ1KjR1yXK4I97S1iAWiNobiShDBujRmmw=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.13.1"
      "sha256-thtnloGS4BEg5bdnEc4dIOZ/rAaojWQlQ+Nso5E1uks=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.13.1"
      "sha256-Ak4nOBS8PlchtSZ7u2WdcvqcPS8CHx2gkb1IeE7CO78=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.13.1"
      "sha256-lrX9vNiaXekBoqBCUwiRcGrFOj98eAw+1VdtM/VrFvM=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.13.1"
      "sha256-gYTMzWB1EpskiLA+CQvShpCnvJ7PM5x65NavdsksrJg=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.13.1"
      "sha256-BqudWGmHb0LhamtuuKnKf7S7aXIrQQUo0jcdAch1Kl0=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.13.1"
      "sha256-e90/qTD/BfUnlJPwZS3VvUR5MA58qZ8Dz40emRzeqQ8=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.13.1"
      "sha256-rSxR2YdgwNIPAVreMalDA2CBwAjFqmjV9vpeuzexGKM=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.13.1"
      "sha256-pjnHLL/OY2Z30DbB/dG+EmQmw26mpMNLJRiVu75zhhE=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.13.1"
      "sha256-+gsLaRbZBueYif1UC90Ig6gPYTR3OIn7SAoiROg+CQA=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.13.1"
      "sha256-mCpsk5JMKBf44kTImSSK7tUd+VOXRDAwsT3DdOAoW2U=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.13.1"
      "sha256-JnT1V2QCppuYsl8s2UHGHSowVWubTLj54sgV3/D3JkY=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.13.1"
      "sha256-tTib8+P2WYf02iYlek/yp0miVOa1aIhEG2+vHeB1gik=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.13.1"
      "sha256-uNKKj6WvtZStJJhsetQhvPIMpLHrnlEyO+JYYIztNnc=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.13.1"
      "sha256-8M6LEacfNmx7o5wCInAKhwzABh8EJ0yQovDsE5cuJFo=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.13.1"
      "sha256-AxfHzSWpYq0bz3VXJ+8z0b8K55dTGGzs09S83tPYLEw=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.13.1"
      "sha256-N6aLsYFKnrACA/ia6EjiBxQXhp7Pi2TcUUfTaGukoOc=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.13.1"
      "sha256-w3Z9eEu6Ty+yOxvKDyLfwqT7hZLEh7szwXX2ciHYYoY=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.13.1"
      "sha256-KnfpYd7H1e4ftRz8KubCVTqtjASurWkK2Qxfpq2z6hU=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.13.1"
      "sha256-yXiitAUhSJXi4sx/EgKfa3kZ/RWgVnAuA6ieZ2Z1w7Q=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.13.1"
      "sha256-kaQJUyXlPVDTa7ay30X+MCCexF2ZHYodsgI5Bp1J16g=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.13.1"
      "sha256-4BUUZPTbKpbWMCUNH3Mamg0rREiiHt2qic+XVHDKq+4=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.13.1"
      "sha256-jve+PnNP4cmyBWeSxM6G349DbymY7kCE1sfbpDjDTGM=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.13.1"
      "sha256-gT+aYlKxQm0sXB1iPC59x7rzNmHk9V/CJokpKtmnHaE=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.13.1"
      "sha256-xvb+RgzOJFN35as+bWNFf5WvYRpbr+qmhLQHV15aUQI=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.13.1"
      "sha256-zxAn9a/jagk+QDoAtTqw+0E/qGPAHSrWGJzDIwE4mz4=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.13.1"
      "sha256-NQcylhXkGqADCiagW4KNL5PEeGB0dT+ggRjPQSfpyQY=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.13.1"
      "sha256-SAkisanmZM1N2XnKE5quH6HkMugkggEjQbJ1+kq9MGQ=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.13.1"
      "sha256-YOz+MKPoF+NoicK1bbVyNePbvuk4IsauXofTtA7jzhA=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.13.1"
      "sha256-TOxkThUwnulFpdyMFeZB2SjmY0fMDSLkVh15zDEhuLw=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.13.1"
      "sha256-LVYmvDjYKBHumG3jjk1NrDSwhZXF/+9QCbKA62lAodU=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.13.1"
      "sha256-RnEkNwOuI6m0ySLqL8pUzy2DeLsjYfN5EdtlPA7nQBw=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.13.1"
      "sha256-PU2usWylU13a3I/GBmymLqt2ViDvMacfS++cPnhwxKo=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.13.1"
      "sha256-CXWyK8HJZx3YIBID2vy0xB8kjnOBONij8fWlCuYVZHg=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.13.1"
      "sha256-u3ghdTZxEWdjhQVmdv5a/7XUNQcG7NByxzllB4oD89U=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.13.1"
      "sha256-jMnGJ2mri3hzQnOGigTejZVSuElPpacPiTJLp81M148=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.13.1"
      "sha256-eQJWy1kiCd6Ke/vKMVdNDvPitw4rqVtMvmhYPqcZXpA=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.13.1"
      "sha256-09BtkNGhgwjuMaIpc/O+oMQT23mJ+uXrYojcMTt8HYg=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.13.1"
      "sha256-ujnFPsH+IR+XUr2LMRpGw+Ej9ASQjXDJH3nUYN31OHc=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.13.1"
      "sha256-IV05dhVccTKTINbgZevIWBX/4BSlTs6UoQaz/sNttCY=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.13.1"
      "sha256-j67iuVzyZq6Ps14uQV100KVuHgJ4bW6bE3pDVktDVUU=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.13.1"
      "sha256-zc1mEMFn0FcjxMjvRib8UrUMUX1Jp2bAN7+qeOsPe7o=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.13.1"
      "sha256-98F7KmVtYoS4LK7q8J29PYBAXTTz1Uaac4mBkqflYt0=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.13.1"
      "sha256-s9UDZkNyY52aQZS0MNV9g1GMJBGaGNozRLx15Jmuhps=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.13.1"
      "sha256-mFpBl/GVTFOkU7YkrfIVUfzWhhgetmI6UkRj66LeDzg=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.13.1"
      "sha256-awmCwODj+26VDh05ObLDIsqWCARBMJxR9ug/GLBWnWA=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.13.1"
      "sha256-3lCdo3P9ma3lmJgHdhBE9M117NUjDecGCACj7hQB3e0=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.13.1"
      "sha256-cgqvHKBkj/spPFVTL19oWRiYubLDmtspXBek8JN7Xig=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.13.1"
      "sha256-2zHZi66843jrAwXotc59HHbY160whGKMpiUCpo589Qg=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.13.1"
      "sha256-rFmOs1OOYWF1+vUIsuaZ9VcqYVNVPFZgKKBwpkedi50=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.13.1"
      "sha256-YUnUEu+lR236JG98JscIVjdHEaSiIRkDpbiCbh/6XUY=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.13.1"
      "sha256-Sqrr0hJgjPEUjkuatFhREo1u5Nm5dW9Qi+tZXKexvK4=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.13.1"
      "sha256-rTQbNJbMUyP06qm+LTTZ/ivPxnyEu84vNGNR3fo61u8=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.13.1"
      "sha256-6jnWrBqSQdp/GaCxNh7FjIEJbcNiBNik8cxgVr9kPEA=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.13.1"
      "sha256-73hItZdNaqCpN6M6IOfN8YFVbPBGwv3D5VkmWxgr650=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.13.1"
      "sha256-2GE6RCGoc1loaJ5rJfNCj+BRtZqLTLe9csSCA5jHIB4=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.13.1"
      "sha256-S/Hof7uG0BMFmPVVviUkMBEbpV8QjXbsbpfpIz7BSUw=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.13.1"
      "sha256-2WWplzOpmcjwhOkmrjX1a80IlCwsA5tfla9jqS+9zPM=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.13.1"
      "sha256-PHF1mdrFHGQTopPgPvEl+cekfs5eCuUbcPRHW5U2aCU=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.13.1"
      "sha256-hPHBgjvUsCY+eSRkpGzEwLkJ+jrn+cen6r9b7PtNgBc=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.13.1"
      "sha256-3YmkCihwnizc15LPScXdvJ2aDQn10ZbQ7Fqvy4OMDlY=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.13.1"
      "sha256-qHeotLVmL5kJZXA+moqVgxbDg4WyF3MJ/bxX6l7ypcM=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.13.1"
      "sha256-vJg4UFhLHg5464oB9cXl2Ls/rVDg5BQ82CYtTEzpcyA=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.13.1"
      "sha256-eb/6qwofizpmfQdYDRdbu4MAMdsXJk+e8Aoo9zhWDFc=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.13.1"
      "sha256-ydSlw+KitEn8QaGz0NnYljZGX7uYspum136Qvu8PGVs=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.13.1"
      "sha256-Pc8hF8ZDrVD2Wb/MMf99nRx5FpfzBHPyvIg2NaRAnH4=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.13.1"
      "sha256-yM+H0NFlqfkTJAJfr+SZ5shdUMSCWubeg3dwmQjFNxQ=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.13.1"
      "sha256-dXPQTeu3zEtimgdXFJ1KLQTvRxfCXiYabLhl0YpmJjk=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.13.1"
      "sha256-fVGD8IxKwrtxqBYz3yZjxgoy7NXcDYBpqP5Gp7+0rKg=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.13.1"
      "sha256-d2PU9AWighlEsgWRzC3Jdzq9oL0GTTCfcRaqQZL85oQ=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.13.1"
      "sha256-O2SbST9ZOtEc0eANm/D5PakAazJBAmBO8wPeCACRMQQ=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.13.1"
      "sha256-cwkclyVKSsjJEUkW+qadtx/1P953xRntntpVhjGGW6U=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.13.1"
      "sha256-/UJ3+qbExc59yTEfPl5hQl8ti5QDedOmZnZ5QD8+BI8=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.13.1"
      "sha256-GTHNhwOyBApeddCI4lqTHvPUzkzrnnydXudUrUww+GA=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.13.1"
      "sha256-gOdnwTbWVK1KYshuFN+Cic4fqC4sdphYbKG+GTuSDw8=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.13.1"
      "sha256-q0PCBQsNMamebAlxydinILcH6xE4ZCSB37nItUoY5fY=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.13.1"
      "sha256-bwDH6nst28rVEYlMFs6UlcyhpAnZdsoZYzlSu6qulKA=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.13.1"
      "sha256-HqNKZ6DGH+Wdho2bTfNeq72OEs1UzylNPu+nbyf3jd0=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.13.1"
      "sha256-lC4YEVdgp6ZLjVkwygsi7dUsX9vZ1L/fqbk1EpX/DmE=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.13.1"
      "sha256-yniuI6Hgp8XTmRjO74MZRxZYV0ohEE7CAtahIYQz6cg=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.13.1"
      "sha256-bKjZGXIWbCFIo7SyLueX8gj9WWjx7nh2P4DArfsMcFI=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.13.1"
      "sha256-VvbiWdwlApbJcRlAoFzZOG4SekaP7mJVbJCpoF+E6Tk=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.13.1"
      "sha256-pVRELwjlkLApPYUV+f6ax/ijc7N6C3nsqPBeGisB0HY=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.13.1"
      "sha256-bdeTdx6+Pde+hFzqH5Bn4Jk/4fFe68ihYDCXmpbR44w=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.13.1"
      "sha256-lJvrcgICIvcGbwPuYlJ4oT3iceItzkOEnSqdJtJB86E=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.13.1"
      "sha256-mpDPfMZqKQV1PYrK5MqNZK/z9x0ObIiZbScpPSZFb1A=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.13.1"
      "sha256-mFpwV41A5WDkzxSeKxGnw+NjByPH2M40ShgcNCDw+jM=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.13.1"
      "sha256-DIKi/0zz0O66P+CvgrLZRZ8NvqB0N4zlmIcF8DR5fvg=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.13.1"
      "sha256-WO6KbaKvmijEaWCKPbEusudo4vHpJCcSX3aJ6zxWFG0=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.13.1"
      "sha256-YriIVUyOpoC6Ry6F28yNRDuH3gwoYishq4TqUgW3CU4=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.13.1"
      "sha256-HijHsOB9bT5ESGdkwS8m3ulkPef8TLsJclAdum8aWCk=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.13.1"
      "sha256-KETzBkIcOB8pWBYIzFzIYh2/Y7dc0TGBU6tRQFzGBhQ=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.13.1"
      "sha256-mUp9bdMDsAPqnFmDjfCusId6N2L/oqVgDK3jZjO29s8=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.13.1"
      "sha256-0qjcW4bo4LRYtsNde3ft34sjLEDZkvEOhWOQ9T283fM=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.13.1"
      "sha256-OvZuJ4yU5el/xSLLJu2ZY94wiHXCtirBeykiHCVsb78=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.13.1"
      "sha256-sG4tBgtIZ5Gxhg9kWQ/p852XplThz6C46Ck1GsKWWnw=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.13.1"
      "sha256-ps6hwRhG5iofY95IV0oigJg32AxLJ4SVHN6vrJQ2x6s=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.13.1"
      "sha256-L2Cc0AT30rVvRFXg3ESH1g03Ay4lAlQHymG5S9Kr9fc=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.13.1"
      "sha256-is97L08grAhe1l3SKOudv+X08Bn91j5XDc4MJDnM8iI=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.13.1"
      "sha256-hA3oQKMzs4A6JOgZ0LJy1lBWLseeJh6Phh+T9sEaBss=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.13.1"
      "sha256-bZy4/BTpRQ432zzSpJYpxva8204wVuCn2vKXNG8lXRg=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.13.1"
      "sha256-vjVVzDiImqPgP2HEsOQYzpU4LXNAzpIyO1qgAoit2tQ=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.13.1"
      "sha256-WB9TqJahHVmhrOUqJ/cj2zh/eqzVmqzXdX3+0V2PXqk=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.13.1"
      "sha256-IAi/rWYer5DV2QJO4NeS6THQ+dAwR0+EvjsPeIlBgdQ=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.13.1"
      "sha256-XUuwg1HtJ46K3AhRx4l74x6mVfJxyTv7R1gCgeapHOk=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.13.1"
      "sha256-RKJA0GBvEQtZV1fx2W26fF2QCkh0BlEh1FNwuS6hxxo=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.13.1"
      "sha256-bh1qQDmivNGTgQOBxJXlCK4Onmr13d7z9qpdIMjuaH4=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.13.1"
      "sha256-xjqghC+Ul6XFeZSu+tOIe6UCJmAvh5iCZTV6pALk6ls=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.13.1"
      "sha256-07Xbf+aRF1YNjK4MK/dNzmjbyFdTA/Aw/a/XxPLz1mA=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.13.1"
      "sha256-H/jRDzPfruygc278Rey4ZlpSqjJjPAxFfbB5Hwx5z34=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.13.1"
      "sha256-/x0aoRNtAdezLG3+8XISYaHhK6jEJDduIHThdbUxfBE=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.13.1"
      "sha256-N86oMUzLeyorE5kOKzdzNZ7xcPTj3RfMUi8Y/COUir8=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.13.1"
      "sha256-vze4j28+URgY81Huiv9rLhga+3ZpmZbg9Kok7Kj9Hs0=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.13.1"
      "sha256-0GqKRn4wmfqWo2h4bVkBrU8l9rp2l4MEL+mNDzcNk6A=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.13.1"
      "sha256-k0ZNjys7B3Kgh5k71tL8Pe9TfosuMXrjPB8EGk5sHSA=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.13.1"
      "sha256-Xs5k6yyCaSdHTCtWw6Xp7LDK5lpIS2oUv3xBavIw+yc=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.13.1"
      "sha256-DLDVHnrT7OEK3HBd5HOdTx+RQruFOowzVIpg8Sv/wzo=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.13.1"
      "sha256-JOsQKGy81RNaOebeCph4PXrgngFIva4eHCXQlA8PIko=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.13.1"
      "sha256-bxPi1ZV2DOv4Itv/DRoGvop2wHhloj49ovoXBdhWxZY=";
}
