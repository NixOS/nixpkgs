{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
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
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.7.0"
      "sha256-hN4flHBRlkfH1l1gbe6Q0I3blMgc7pJkYnK3HLGSQbM=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.7.0"
      "sha256-Y3TZ2EJqf3xV6qv/eb7GepQQ+v1+lUOeob++oY5bA7I=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.7.0"
      "sha256-1Bb1khmPLxELWjZQeI0IUK6OH7g7fQoLnfre5t2LO/8=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.7.0"
      "sha256-YkpGQYQtesSvRa7dvZiRGCzl9U7/2i9TMc1N+ZrTmLI=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.7.0"
      "sha256-zI9vxHfMGvAUcc191OdU8DIocVCaAUWZZ3+5e1o92Do=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.7.0"
      "sha256-UxNsUeVcG1IcUsAAoODx++aOJJrrPqLFlo6y7y/5Cpc=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.7.0"
      "sha256-gVfA6bLj27ip4QeddGd8fD3XnB+yHZl1VG3RzCxqOXw=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.7.0"
      "sha256-8gotXVdpNHE+4BAXCAiFCKJ0aDLN8N8ROGgq+rdDMVY=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.7.0"
      "sha256-WV5bLhtQ+TdLfblvtBfL/4eHoF+x5Exaava3WOM86+g=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.7.0"
      "sha256-f7UfO264MPyqr4HyIk7sv9tzebHx5HYxKrR+lCczrW8=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.7.0"
      "sha256-PVKmM72M5w+gvzG6OM3ecInNxhbVI+4Ny/TXNzeqwzs=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.7.0"
      "sha256-uOsEkffmklTAXOOAXx705I5J5jCh4pITc4KL7lx4Jlw=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.7.0"
      "sha256-AVQLgT8b25nrspFHiBalxdVqZfq0N2G77FAuf4+JkjI=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.7.0"
      "sha256-51esYq5HP7Y/wUnw80+WiSKZ4Od8kDZ8ylgoHecGsSo=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.7.0"
      "sha256-BbCpvi5DAkRitJiSHZ2CxfTi0ZjxKCeev8xItokvqiQ=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.7.0"
      "sha256-qM30c+eZfhnbLJDgKpWoXCQFegib4GPogrEE25KyXKM=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.7.0"
      "sha256-QIyG4sWYbvDpd4yhjh+oOKEnWrqGPE8cvu5hHdNMEWE=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.7.0"
      "sha256-KvjcCJnUUOM9x5yav2N1D/RabTZzH9X6U21pqrLMIAI=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.7.0"
      "sha256-KFbtxYvLTBNqbETnVynXAg+3FufhHAgqllV+LiMqEvI=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.7.0"
      "sha256-rL4I6n/Ma8OgSXCkjS5p+tgwVsda8PldHQ4Iwb8I3hc=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.7.0"
      "sha256-9tHP+aFIoVSC/E47oGyyzg9c1pw88pyTbANwr0Q2qj4=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.7.0"
      "sha256-QHi5ZlHY6jybgVjjV+Js1hYuxfNHz88dSYnZYg7DejU=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.7.0"
      "sha256-DW3cMDgBvN03nDpKXRWCq0Wb65XHl7TZVg67WVz5LD8=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.7.0"
      "sha256-fAa52ygaouYw3MsPavXVtuPk6inNETdEjV+6HiRajZ4=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.7.0"
      "sha256-LMPz8jx1Vz4xS90cbkadCyzmkKkk6ajWvtAoisiGpYM=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.7.0"
      "sha256-BvSJ2iNn2YplD2qv5OcFlnzQKltWcfhYnJJrydkFazE=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.7.0"
      "sha256-KgrvKWJf8Y4TjbnaQyAARZvQww5QR9R9IS++kSxgNeg=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.7.0"
      "sha256-RqL8kuj35Iu2SnBGSc1EzGhwLSiOhQu0QnuY9CtS6+o=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.7.0"
      "sha256-qDP+ekgwdencTmlDProJKbRVrIY/JPEnccgBENOJxP8=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.7.0"
      "sha256-eqVZXJyX9aJsTEpe9q6GOMY8BwACrtTV+mnozP12GCE=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.7.0"
      "sha256-8LoaUgIUDs4IZOlBJKsRYMvxT1+vlQJtkotM8duCRPo=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.7.0"
      "sha256-Zv1QxwgHTPaI7cZ05KlfR22wOwkeDRYsGwj3RdUHNjc=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.7.0"
      "sha256-ZG/AahoSRd8slVCN1REXrVwzaASNLQ38oSkTHJ2VGYo=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.7.0"
      "sha256-KPkylNUiyHgidbwPmWFvzLfpMnYD+rJVQ/ojtYXBcc4=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.7.0"
      "sha256-a+vTv09WuO+EvhO0+O/YvnKeIibXH6SHRFGuJHNsgKg=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.7.0"
      "sha256-RWTU5qNV+QDC//CZ+nguM5/fDrT0gfGE/aKBxjeC0kE=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.7.0"
      "sha256-FuYd2jjvoqy7rp/7Bglkp+8rfTpHsQzJNSrJxAtABTk=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.7.0"
      "sha256-WMgtfmptbUP/0D+KwGAaMBesiGxEyNVh6eQbJr/z+UY=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.7.0"
      "sha256-JY0N+gYkRhiDu2lOGy2xwRAZnHwpUmYg6/yv+s76v6M=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.7.0"
      "sha256-La/ayhWHzgwQp6V8UcJHrxzB8IezGJf8VtozFZeAroM=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.7.0"
      "sha256-LGAPTc7MtktNeeXb0Cq+ZEfpHK0IYE7dQtPd3c0IAA0=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.7.0"
      "sha256-0NPNBVw7P5eTGAhbYueod/XSJKnq76l1wVzC498nqsc=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.7.0"
      "sha256-R5rA/HiMJcmHUkXEE4oIAIcd6LXGA28kuGuEW8IVYPA=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.7.0"
      "sha256-xTjjkmJ2fl2zaMrgyeNyD40aHcwpF6UXxn/Y5C8H8xA=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.7.0"
      "sha256-s0lGQQOxRnTy/+jkxEB5iPG9AAf1hRKSZzxjZOavcW4=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.7.0"
      "sha256-yw2equ0/nFY1Jgntz0/uCadSXYunMXKdoMcwENmxvHM=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.7.0"
      "sha256-jdknoRGB2saxvACfuJfe1WsrtGRag6YX3Ar99nf5IxU=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.7.0"
      "sha256-xo59zro/dZNiE2elY9chVyAmbe7l27+duOKtBO5ubHM=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.7.0"
      "sha256-jNYy4RqVM6EFqv6f2OMU7i8DrFPI6LUFeCwywdTJgKM=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.7.0"
      "sha256-W06pYhG9tf/sipjRNQKwnVMDPdgGAoeYcIYtTao62Sk=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.7.0"
      "sha256-R2SqB3l31HgXDO0MJh23eWtmMCN22kETpcKInqBZQe0=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.7.0"
      "sha256-aVCQhAFfJxjBTybddLwNoZFxnRYgnw42xZc1mrlSSy8=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.7.0"
      "sha256-v7LogXqKff7ht+nHNu33EW2l7gDYITF63R+CMGim/Os=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.7.0"
      "sha256-WO5MpjVFJ3T52s7ErlIaS6n0kvbRxeKChRCeZGDCjWI=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.7.0"
      "sha256-+b1Exmy7k3B9/rfhAPRRTPJgLBJHa0VGCUJ7jjoZX2k=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.7.0"
      "sha256-ioutudILLyYw5RWN2mKkKWQ/G/VIoHozmnFr2gfGv9c=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.7.0"
      "sha256-SiyH0cnHGobGHY0b016tzlfEvxAWeK7o/hf7VjIu/mk=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.7.0"
      "sha256-53J3i2FOoMscK9F5axvBf32s+VrCE1e4wVsf2JS5k/k=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.7.0"
      "sha256-rvClmbFk62L8EIqxD1uRzNAWMAvPPfbfAEOvmVWlEsg=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.7.0"
      "sha256-0ri/DlF8t86tLy3IkTaZLH/ZOLR9v/kQO2asJlwD6qc=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.7.0"
      "sha256-M2oVkK/bA5v8Nq1m1QnA+1EX0Bo76xNGPyXeysq8NXI=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.7.0"
      "sha256-cJIlVDaoaC5eW92f6276qLlbMI8o+ReAbSJa/9CglKw=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.7.0"
      "sha256-COcNBKEiuUwNdMPX/GxPolFJj+P2/eqjHBAE95rQf2M=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.7.0"
      "sha256-dcXGwUGXZdy8w6++IFNzc6Lcb22FG10RpSp+lJTMnSM=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.7.0"
      "sha256-7IrdHV674OjUW1m7PTM3G5+hSe500sY8rY3m3VTHkqQ=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.7.0"
      "sha256-C8c5SsKP882yrgNNbVM2gyqqadt7LVHjCwt/EC0aHhA=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.7.0"
      "sha256-XVas2vKprWZrWRSzQ50XsZc4bjBK5fmyJ9jRAaBZyWg=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.7.0"
      "sha256-ICI+kiRFPP9ddpEsIEpan1RXDMvRzIzSrzP6E3Jkzpc=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.7.0"
      "sha256-XLXJp0nVPsszs0z7qS3rD+C9IovozcX+Tr2FLvFkXXM=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.7.0"
      "sha256-ak+hXx1NAw9tL9iT6iOG09tQYHV5CxQywxbHkRR5EyM=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.7.0"
      "sha256-FIo2q77bP78+nTynZiEMlKaQ7NMesrl325Uj9WTtg78=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.7.0"
      "sha256-rPEbxlmWJG3mg2Ithk4ZOU5NbxRA7+QXbHZsycBUeWU=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.7.0"
      "sha256-0F0iIpmwcivX0r7SP7EogYCaKG0j1iujWgGkUdXWYUo=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.7.0"
      "sha256-J9G0qMTXaOyW6RTY1jIEFCxUswElkdPx1hqHlFtTXgw=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.7.0"
      "sha256-Ie9B4OuYjzePqNf6Bvc4tq777YWIljN9sNWQWVgyszA=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.7.0"
      "sha256-/RUg/woLn9qm6bonp/8DumKP8auEWdrtqne8+2s+kdQ=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.7.0"
      "sha256-q7Kffps5ugA14xf9DHynAhHNZLcOP9HO85GTCTyuMq8=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.7.0"
      "sha256-EVE6JD9a20FX1ASvY3jJyXn5SquyG+n/mUHzXS3EM64=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.7.0"
      "sha256-8tIUgHaTd1mNN0na3vi6K8vFf9aCDn8OhlJyymJVqZM=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.7.0"
      "sha256-h8+gkONNokS2n4u0nkijcNdblsHHC449B2wQjDIC+uo=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.7.0"
      "sha256-O7s257Pb7kDbhgKxVYR3pStZmbVjP5MDE0ZN9Z3oGG4=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.7.0"
      "sha256-aiTOMWHCVVXNQjyaYnqnUn+AvJddfe1Onxqq+7C8siE=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.7.0"
      "sha256-X0ccuclYoQ4YsBkFnevEzGq2uVuU5twu+CbEEM/zUeE=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.7.0"
      "sha256-19hTbA1UNLzybIZxiV2oSPAKJ36YkdfWIU/Wks63UQk=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.7.0"
      "sha256-IHr4Az6ZRdSI/v7NUO/2FsUSdnVYtqG2jb6+CqNa9Zs=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.7.0"
      "sha256-AP0XaRclqTJ8fMAdJzazLrfjeM5vx7ejcVF9+WOg5dg=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.7.0"
      "sha256-vjFmcHKGerivLXGruRA6fLFTxrAKBfeGOv1rgvVlYd0=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.7.0"
      "sha256-gr9C3CIZnj/I0+GkJ8FfkYTUnMcr+h/MU2Wi+G1pFws=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.7.0"
      "sha256-rsiBPL6JG68BvhExf0fCsK5BI1zGajkAx5ySOy3JB2c=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.7.0"
      "sha256-VgE4PnoqaEu8rV0TKGtQ4XDp2rD/gXpxBIj73HSeGJI=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.7.0"
      "sha256-Q0F3q6//CmcPrC0LybjzjzBBwvQJgZGk4wZHYJ6PAJ4=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.7.0"
      "sha256-tPDm9pG53NW6bLbcIbXmjrVDJDeIJ07wMylvCvM4+yk=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.7.0"
      "sha256-eKeYRnLRSk+PQCYgWFEFnnsUmtrhNKtZPa+M3GMM1t4=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.7.0"
      "sha256-08KznNVQCoGqGS2mDtbYISW3JtpHRPpa/WIKfbQ/i/M=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.7.0"
      "sha256-2RrVq3pGIQWfU8uI2fhSBV+6VjSnEFFnb9FcYEzTLl8=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.7.0"
      "sha256-oH+3JqSoeHPI4OXMzZa33QJiMea3Xw5DDZl9DmFMXVQ=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.7.0"
      "sha256-2q2UqQ+mCOA3aW0fOmZL/Upi1b0GPuQn9DyvOIkNsMc=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.7.0"
      "sha256-UFeXnz877xxdWnYIKMUNubj3LKU20sTCsORYf7sgt6g=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.7.0"
      "sha256-uyPJkjc07Y1GHaC4oRZqC42QgOY8LmXjLNA95XCAVV0=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.7.0"
      "sha256-ir0ffWxtGEPihKirKzeEytZbrTLb6FdEH7NZHxBJlmQ=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.7.0"
      "sha256-3lZv6kh52tiJ2txUQFKrLxFwkKY2+LPAAa1gcxzr4Ds=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.7.0"
      "sha256-sr+Iqn/vW2jxXCYw3qXi7O9tqOaPdiuAMABkr45KkPs=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.7.0"
      "sha256-kBduFFziwpclOQlKa/acLfHhG9CKl7JFn04vYkqFnEQ=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.7.0"
      "sha256-jwO16n53l+jLA/zHpNG3PU/iWUdCuT+mgipyjs4I2hw=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.7.0"
      "sha256-DiEksJtfYzDJnBXGRtnMQdWQoWF+g3VqIXwJ0q2sZxU=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.7.0"
      "sha256-1BPbC4S2TTyT2WquZS5IMKCjcuDFC89Bt0CKUnTBP3M=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.7.0"
      "sha256-wT8rpC+EUwQp/Pk+9hfegciidAhBmN0mWNcQ2qbv4N4=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.7.0"
      "sha256-j3ZSATOlw8t4mR9np6qlI40P2cmK0H4n+RgUr+tw/P8=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.7.0"
      "sha256-mDnDkYsSk2Qx8mQ0I/wCGylvGed9EPS6ivxQ04xyKBQ=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.7.0"
      "sha256-/8YzvK0QuVukrgPI6L8myiQs1SPucHejJ8h8rHSNWj8=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.7.0"
      "sha256-vj+lD8Ua3rECLi4k/iDOOKq/K3qXeWgwkDyWEA010co=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.7.0"
      "sha256-2lb6+htHa0KH+hCoCyTqoZFLSKC4xy06U9+gaPWvkw8=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.7.0"
      "sha256-yCjZyhPmgO8OCtSsvqC4zob8pSueU3QxlksHk4kMpkQ=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.7.0"
      "sha256-PvUdlmKyamrb74vB+A05VbzL4Okv12yYL0R4RGFKTj8=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.7.0"
      "sha256-Eqx3r+g0T4o3btTjd3xW22MiYyJmODL7/52j8PMZhKo=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.7.0"
      "sha256-KsPRUUuFpw6Fwzni+1chWOX1d5N5YTMIPcmRhsZs+QQ=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.7.0"
      "sha256-rXSIfNV7ZDzH9j4zDdyeD9vEYmpu8H12HCNOUCyTk3M=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.7.0"
      "sha256-qKTQ8cv9xj/E541i/IWWYtOSd7n3I8vO4INQEws4gvY=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.7.0"
      "sha256-t8g9Lom5iJi2qLfaLf47VkYYL55CcNFPrUcGRIWCJ+c=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.7.0"
      "sha256-0sObPw4IwlgJaz4OBBzPXmfXXdIhBvMTjrGZC4BEm7M=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.7.0"
      "sha256-6PJCcEqA7WU4KI0I7un/WAHJlGYefmHsvz2wZzVoOZU=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.7.0"
      "sha256-w3KkeY2i795vZk7SJHN+LIhscs8rt9HjhnWDnVbE12Q=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.7.0"
      "sha256-28IP5s87+Dzl7VbuEtfXeVD5d8M/Gg7DMiy7pp6g2t8=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.7.0"
      "sha256-V8126NUZHRY3Jn/vSZZZbyCH6OhZy1Di6oJrq0wjSkU=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.7.0"
      "sha256-8IUJNiOh9iFfoThoj2AcGasifp7/nJHtE/6pjrmf0Zs=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.7.0"
      "sha256-nSeI67wVdDKP6VV4+EW/zCWYNtXq87db6cKI2qgTkrA=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.7.0"
      "sha256-6LoNmKGMSUFkO2Wmu31ZIdEGf6aOGqYaO4mSOP6inM8=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.7.0"
      "sha256-FpSKdklaIzkvpDjbCFZcRDRrKevDNJHaXMcg63H3xbI=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.7.0"
      "sha256-1oTB45z6BWf2eH66AsCkEspteBL+374Kwp/JliSQaMA=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.7.0"
      "sha256-bmdHgVjAEJ5mS7CaHtR37giYYyVGenASbSDUhsPyQGQ=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.7.0"
      "sha256-fXtV1XhEYW8bWE0C2nbMK9BCr/dO6tCIskANVi8SA4Q=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.7.0"
      "sha256-5WlTOidHtsVh3rKxpfIufALneg+9g9o+D5xfrLSEFPo=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.7.0"
      "sha256-/qUvIz/Li2P/Bh5wEY+TaYgNqFGvHrl5OOoeV550ofE=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.7.0"
      "sha256-KHcqQIUtGuW2x/ETnvscsNZFbovB+qM5O/WE2o/8lL4=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.7.0"
      "sha256-Qm1UqudmcuKKghvAlxU8EclyUEtcnOld2Xt7Z4ihF+8=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.7.0"
      "sha256-3/13REWwu1NoIp//wwKMEV37Gvz+guE7Cogo74kCPr4=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.7.0"
      "sha256-PxBziC4y1XuBbXj/+rHgkXY3OlI6tTSKIFW4IrhKG6E=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.7.0"
      "sha256-UFSnAnmBFmTGJ9dcFBV36wY8RwVGUrASNyk6Z0Yifi0=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.7.0"
      "sha256-Y7rDElgnSITjTebtlR0b2m5PbuNNtW95vzCtXnJj2s4=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.7.0"
      "sha256-oLxt2MuYxZvaicJT6plpLlBCHKNcW6Njv2EfuDtWqQs=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.7.0"
      "sha256-OhEGCdrz/CZdsaiMyQa3+VNhK3SEk4fq0Hgt5UPcr44=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.7.0"
      "sha256-C6RQGD6FEbIiuEGtvTp//fTFsYRVyFVyXFY6Ke6aUko=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.7.0"
      "sha256-HfKDrkpoaEBME0yvifeIKZmDhr95eJLti7v7k1226y0=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.7.0"
      "sha256-Ym9XIYxZ2ufr8YAi4aKDRvN6LUBfC3pNvqjzZB7KMe4=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.7.0"
      "sha256-oIKsmv6K9HJlq6KTmbTr/Xj0k2Hu899zxAQXp27GF/E=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.7.0"
      "sha256-SWzP/8wLy44f4zL+aV3Th758DW52ABuVQd0sgC1umtk=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.7.0"
      "sha256-tnA7BpHJ4CexvLbhnZoE4vQbb3tFEklZXTbmoUzetpg=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.7.0"
      "sha256-gjikqLNIOKC98pddZMncHdlWLQzjQmHoL6E9RQ4D1jQ=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.7.0"
      "sha256-esbnmtowzZ7lyVOpPV28D8xJ5/FPkQX0Qwm+XMAfv3E=";

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
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.7.0"
      "sha256-pAMFk90d66BOEqKkNH+QY1GI5vkf0qFXUlBCgWNcE50=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.7.0"
      "sha256-55pKYrOWYbBoC01qzwB39yqeLwo6itjsLkPn0x8t1TI=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.7.0"
      "sha256-FC1oSqIHnxlIgf3HzIIvfdkQ5kpY+AnAvZBGmY9k8q0=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.7.0"
      "sha256-ev+EX394ua/ZNHMZdWfdvY5JRJi7NHOWvsbxhE1djWc=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.7.0"
      "sha256-RAGnwWmRW9BeqxK2qldFMY8fh4Y3QUG4usWFUVJc6ac=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.7.0"
      "sha256-3x/g1dYdAn6B5z+Qc3tIk13LsQx73W+uI91rVrF239o=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.7.0"
      "sha256-b25l5Ol+apkVJgq/TCzikX22MU00H9PKLlfF4uaNHLQ=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.7.0"
      "sha256-re7NmI5Qj9tb9+RzxqIlAug6voMuOXi6+xjgptsidfg=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.7.0"
      "sha256-HvvLL6PYWW/WUUBpDE3PfB7+hRvLLtCOmwobEdPsyYY=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.7.0"
      "sha256-3+cJAl1h7w75HvmMvDoG2brOfMzTBvnHh88BhXmkyic=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.7.0"
      "sha256-W5hU71ZZdOTl1dtlAIKqnAUv39ovzPs4vl/w6KA0gxs=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.7.0"
      "sha256-Gyk43kjQmNt47MR2VbDq4bFWTWJ0UnNDHt2UBFb5tVY=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.7.0"
      "sha256-ebBScLc20kfdnKm2os6n7MUrGTeZo6eXYR7nJCzergc=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.7.0"
      "sha256-SMSIoG34aeFm197vQAe2KQHEtGApUya2sY6othhRYRQ=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.7.0"
      "sha256-OIb4U993Ofjb11F5Rr0B722LrT280M9bAgebbrqcdlU=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.7.0"
      "sha256-0kUorAAX8c85DaK1tLCB3+kfRhSLgLeymwW+P07lh70=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.7.0"
      "sha256-/+d8uU49ECUa8n54rHI+35fG7wwXBHpblf1HZiAKSu4=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.7.0"
      "sha256-R+guEYKMgzXxZUF8QKi833hJ6XaLMmxWAWy91ncXll4=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.7.0"
      "sha256-BVcx4TGVRYZTuOOZzg2Iks5TXeq+vAFcij+QSeQ9svE=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.7.0"
      "sha256-TEfXDpFrxyyiEzkzPUQsA+m6nmkGH/HeeGX4BroBuNo=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.7.0"
      "sha256-A+WSXNq/LSaMeAvBKSk9VQWysF29DoJydiyDwyZFuus=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.7.0"
      "sha256-iI3raCdgb2HEECR24HsqRDma9aJKR16gxWPLjsxpTEQ=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.7.0"
      "sha256-K4gHQR6Brhb/kV0Cwkq9Oi9VsQD+3AgerzOIegrbgCc=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.7.0"
      "sha256-DSa+PtKezDfUDyY2SGSZw373zWrrRTe6s08lUK/DAz0=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.7.0"
      "sha256-hS3yT+IU7Xcaw1xZX70d3wj3T+7r00jbmrVARsLp39c=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.7.0"
      "sha256-KTfLhBF5045trIEuHci7qjqvNVdJhAKaHcrIv/T4sxw=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.7.0"
      "sha256-b4anWJAGn8cL9SQjCMFf9xNcOOY0MclOU9ecEnJotCk=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.7.0"
      "sha256-hhjmbBwTzimKrqE159ibSh+DtoTHzA9YlnkYGwJJnJc=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.7.0"
      "sha256-vV/4Nl3ELcNSV7lZ65ViOHvpioqOEtTRSyHOVQfT73s=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.7.0"
      "sha256-2UYtKDytIwMT1zLAn4dUxICrpNFWR+kBsThvCxK8aJQ=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.7.0"
      "sha256-nKN9IeGRw61x19GZ4y5icE+dAMB0GXHIRT8oh4WpRKw=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.7.0"
      "sha256-p4NDE7+zD79nrrIYOaVz8lkBD90AfhCevcbkfqfY1Eg=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.7.0"
      "sha256-mGF2VTVdjbLl8BHd3UY0qoC9YsffI2q118O+s9tTQxI=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.7.0"
      "sha256-pV3XxpkyNwhhhPcxm6oKYqvYblQs2YljltZqo1uMlq8=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.7.0"
      "sha256-aKRDwrS6IJXcLr/YDFAsdfOHW7z9yOGALqwDcTd22UY=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.7.0"
      "sha256-rLnfIWBZb/NlO7JJ3l6H/1upo5QXl7ti1cSZfwjzzKs=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.7.0"
      "sha256-50MhZxpCiPxReKMwF0W+5QGXwPNU4Y//TwHKHvlhxA8=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.7.0"
      "sha256-2cKO/R6yT7uP7+CFfPPMi/e+yR7O/14hqp6XY8CaalM=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.7.0"
      "sha256-0n8nOUlpG2DwLItruS0rV9f5tPLNb1FxQilq02+qvBM=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.7.0"
      "sha256-26ohDMcZu1D2LdKL4+g6nGnJj1wA37Ap7hpnwk1ndYM=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.7.0"
      "sha256-h0FB2boqcLTxH41i354OXTd7K3KORVSn/kaBaHXuCIg=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.7.0"
      "sha256-Z93SanbnjcJNE6LMsQ1nXoTBvXziH0cDA6QpLUZgfdM=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.7.0"
      "sha256-50F8u/yNHqPP9ajuQxsaswZ7/THwa6Qb3tN0dH5KJ6A=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.7.0"
      "sha256-EDOLl8tLN9bkkY5xlvJ0DriSUd6zKDN69FWvy4d1iNE=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.7.0"
      "sha256-O6rRe0lXvmRJT2rWuxtedQTKURsa8JtcIsWbKqEQrx4=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.7.0"
      "sha256-RbLOw72DKVB2FVEvXMDa8Ouio338eVbjvQFrl7tgyv8=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.7.0"
      "sha256-GVkMEMBN+gZ5uNs9OIGUJdqP4xu9r4Lfmqx9PQhr/5o=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.7.0"
      "sha256-bgPnY/uoux2DMJLXckptUZ8i+JykTuGHpI0Rryee0x0=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.7.0"
      "sha256-IbyWAA75EW+gdgoNuAjSmoJPowfWN9QXAcu/PAqHfp4=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.7.0"
      "sha256-+IN5LP5YXdPMD0bFtV7fTbdCSfHUBnYVwv/9ViSbTbY=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.7.0"
      "sha256-cdanrM2oyC1WB1A7QqHwWP05TSMM5znFsBuMEywpqRk=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.7.0"
      "sha256-fH7AhkoSIS8H/WpDCFPMGoHysKm7om5WOvxQV0PRpkw=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.7.0"
      "sha256-Rf/YMU/+87Ow46SYOTo31Bw4f4vNa2ehl/+MviHAiBU=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.7.0"
      "sha256-f0oWra49sGxwHanbiGL/Tr4jtmW+L/ZebuoihIbJ8RI=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.7.0"
      "sha256-LiXRPLNDdD3EZtxA91KE7PwQeuu7UTMy4h2+2UyvAu4=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.7.0"
      "sha256-4koH10MxS7Fspt/46Fl9fDP2n9qQZr+xjBbIkB6neFE=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.7.0"
      "sha256-QfWmkSyhQaGvKJUzouVjuvuMZNKI05D9z711X8JXwqA=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.7.0"
      "sha256-Fblevjw0kgxdiGZiDOW9weTde0/bvOJnbxy6SYzbeJQ=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.7.0"
      "sha256-7pHSbM1pbFCFYyZyVHtNeR4I1NpzVn5PJTHCGSQOTI0=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.7.0"
      "sha256-i6mS7XiOv2p01gGEYG6Fxfrv8pu/gBSTUTbPKmIZqTw=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.7.0"
      "sha256-BqDHdM/QIuPZJGmFPULrcd4iBmgtIbZ9/YJgpkFyN7E=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.7.0"
      "sha256-y60op/mf/uCaRS2/VVVEV5rFnjRwgX7KuS3Londw6wM=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.7.0"
      "sha256-ajIv0gOby+w/hFcsqJGVZavdNtwSOyopLW1eV3piQTg=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.7.0"
      "sha256-/GatR9n9ILxDnvBH0pTYAD1kQIm3NYPt4P8/au2YYAY=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.7.0"
      "sha256-C4nnrlJ967Y5GKawRd+r6pUddZis2J+p+GZJPtWU7w8=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.7.0"
      "sha256-zHeGd6dmRpzPsKIFNxlD3OZbNCFH7MHGvy1efCOdvDo=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.7.0"
      "sha256-097F7wyV2MDe6PQb0FVPEBl3lbjASxuBN2L2/OD7Gy8=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.7.0"
      "sha256-MHIv0SSsCfHTL/toCQIZ3sbS6qNEUgPdtLLFLUzsewU=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.7.0"
      "sha256-+mrwp/UZkYABXKsj8QCEYPIMWkKKkucrleYZstb2p2c=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.7.0"
      "sha256-TACN40HBZMyFJauZxyl/zkZ3E0hpKClXQ7Zu+IQIl4U=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.7.0"
      "sha256-MpE/onrGp8MojaOsG7W9XQXmpRBpTg1omX4C3XWRjJE=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.7.0"
      "sha256-Xl7L6xJuJqrylDv5+TDN6QXlNP9mwcedfOaQVdOBhuw=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.7.0"
      "sha256-ICDHHEGzqZjhwJhz6ixzYmbkbi8BAx2xwKMA5VGwxk8=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.7.0"
      "sha256-n+Ql55Ez1yBoBPz9liiIBvAd7EOfb426CAI9YnrBnlg=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.7.0"
      "sha256-hy0V/KEpom/cLWqA05M2gIanqfgwssDmpX8lQRvxrlw=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.7.0"
      "sha256-MScBO8kqGTyiR7QPPHBKiWoRYPumJFKpWMpk3Or9dFQ=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.7.0"
      "sha256-X6OpBYzayqIBgf/d7xNjvykOu6F4fBc9wPCsL1EkzLs=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.7.0"
      "sha256-pFRQxEnL6iaxCbPNF3veZE1cUhpdLF/H2+e8BFzRmjI=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.7.0"
      "sha256-2JqM7rFvb+GOJj9g34RfnvC658DGxmR2zCmfSn5P3oo=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.7.0"
      "sha256-6sYcu1dPGuNButE/QiFxekliyy9FrKwo/56lVe08VbI=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.7.0"
      "sha256-LiOfdcaJccXv1gCwIqdJ4mO6BgwR0Qe8+W3/caMA5Zg=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.7.0"
      "sha256-CAvnEMX7hfAKnl8VSUAVk1KLvm4SXMRNR7HlthSzy0k=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.7.0"
      "sha256-oj2oswbo0sZ9lJ8Sa7Vb9w+Fq2LQTqBK/krZpSyWnzQ=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.7.0"
      "sha256-Od3FqXiKKb0JlpY0xh5RLylKGA6HMmvb4KqeXm/aeKU=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.7.0"
      "sha256-A30vr6kQKDsfHfvmrslKJdbsXLAmhT+pmqFHmQ6q9kc=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.7.0"
      "sha256-t/ijYqFZfqGSUrA1UshxCV4PZsDWQWzcGmUugD5DNgY=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.7.0"
      "sha256-0DAOHdYMd/YNmtTOoNcQXh4UDr9A2dJacmck9b2fL8M=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.7.0"
      "sha256-kJXcyOgXif+mmUbU1uKXfsOm94WfgsIcVeymaOHr99U=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.7.0"
      "sha256-Ps/gSJwoAMX1NN961uSM5Sxe3hMQewlJgn7A2zwYCis=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.7.0"
      "sha256-S+03Ujuxg+PdJzedB3kbDHxBC3JKrdTRiOXtcY2kbfQ=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.7.0"
      "sha256-muGL/lOWt2mRCQduEOC0jYxPEECeHqNIaIszXwNVCJI=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.7.0"
      "sha256-TKuyEigjUuqx5pNU3CPXce+vpp5l9vvp1vOjL8sr3ec=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.7.0"
      "sha256-3OMotaulvLUsnEkpRicSyQNnHfwfG190fSem2+yfKIg=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.7.0"
      "sha256-PoUit9W0/vnqQIdEUjzAoq8wgLGCN5+Z0gh7MK/akXU=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.7.0"
      "sha256-XPpNfJlaH5+S1lXX9ExJ/Z7InAira93TQpI73/x+Gck=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.7.0"
      "sha256-xXjZghdJfD63mEPatjo3we+wXr+RhUm5SyBLM9DvmbY=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.7.0"
      "sha256-lOkl3CjpOZjjpOQT3J8bsP4H7l9JybJX5w352LEAXR0=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.7.0"
      "sha256-N1f/0k1IlBzg7UbF/Xuty6DvJLnPdUOxhqDYalVOxJ0=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.7.0"
      "sha256-9c/PWUy/c/7vrF95M/lZUJ6Fp8PvhBX1Jzff3MeAnpE=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.7.0"
      "sha256-fo9upMExqXAjcQmCeXz9pDXBW4ppOe+EHHj1sOuQvfg=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.7.0"
      "sha256-H00XQfkDIBtmhEuAiy2+V+er+P2MsJl841xQAipAcHo=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.7.0"
      "sha256-0PUZiN7F9iQxYxN9ZXb6q60UNu4Ce7sC34TSPOOzyg0=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.7.0"
      "sha256-YEPKovf1EwVjK8MOBfCdASiEYEHoamd+qe+2OcJLO4M=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.7.0"
      "sha256-L+r4SEpkqJ8N06aep1cqUEO8f5fUjJ7tnQs3fCPeIoI=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.7.0"
      "sha256-rxnUK4zmqzgZ7IfnUzSE/koWjbcNoJHMPlLty6Bduz8=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.7.0"
      "sha256-Vb1COcRDR4EP2n2bfkAevkzkaFjyQHTIlu9S/mq0TPY=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.7.0"
      "sha256-67P+o1UgbPWbPUrBBDKlY6CMtobnWn9jb1nKmvesauw=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.7.0"
      "sha256-CyQAy6oRXDsSJV3fGwIJ6oJR8qpnFsh8/hzIV6/LSWI=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.7.0"
      "sha256-mxb/hw3iqG9GJk3Wd4ONt0PaMq+7lygpvrdaPuToAAY=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.7.0"
      "sha256-mWsX2sEiVWRBksrSe47GUB3WM96xcDhN0xJnloCmPVU=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.7.0"
      "sha256-3JJvVX0doMsYqLxXJvltUo+NqP1JI9FZTDQU3vGG97w=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.7.0"
      "sha256-Oas2bcddDi1jXMtzp3qzYxS/39vWY991hQ56qgVUH2Q=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.7.0"
      "sha256-QykAWBDH8SmjG+NKiYxwjGD9YMZ91FGRZCl1z/qfHos=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.7.0"
      "sha256-TJx9I+olL/8DZjykkaxwxiGj/MiiCo6/9C6u7ApK/Ss=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.7.0"
      "sha256-BvwQD5G+XSMOGfjIHPi8maS545KRz5h2H/lecsUn9p0=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.7.0"
      "sha256-bsc4hT27qRM3B5kbmOpNqxn3xi4Cs8ygFubNjj1oRXY=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.7.0"
      "sha256-k9XJ+Md/6cehqW4fdDtcqPNqaavwtKN2n86wjmCsX2Y=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.7.0"
      "sha256-fHup/cVHoqAPRCZlJ4k/E7GWv5qOBaFjgUJ/gxmW8gY=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.7.0"
      "sha256-4/4HYEQaKkwBDaEWAxPsMdCTdxe5s5sC3V75dLfomdA=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.7.0"
      "sha256-GuYO59sV8hlm9XldWDvf6ZZk8Zaq1sYhHNufrj8fMyA=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.7.0"
      "sha256-AF8Mac03UB+D8D+mRExpHQWfRKRmbvH4vndmErpMxvY=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.7.0"
      "sha256-xi4QbdA63RXZ06kuQRtlBujUD9pPZmf54qaULnRAXLE=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.7.0"
      "sha256-ciTDcE97Z5M/1+cBYMyeMFh2LS+/3xgodw48W9NUpyA=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.7.0"
      "sha256-c8tPLcfg+UNrgUedC4JGEaCtcH3jAk6Ze7Tsgp6I+ew=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.7.0"
      "sha256-Oi79+FCQgwWve4L2R9505dj8FPi7wD0QjQm9rJHF/0I=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.7.0"
      "sha256-GAWKfDaMToJ/G3djeb8XSIS/+RyCf47ayLF1fpU6XEc=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.7.0"
      "sha256-u3QpAhtFisanKievtIuEh8klEeD4IYndPIZ2Nhs7b2U=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.7.0"
      "sha256-dtAoC5n52YYx7jGK4Lh8w1onHOrVATM18umOtaCgyBI=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.7.0"
      "sha256-ODbg//Vt5WVGWNXWOVL4A7KIvsCuxIaHFL6vwiH4Sso=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.7.0"
      "sha256-Q34iqqWkzProVV2jE28eGsf2xauMp83QTCgQlfbP6d4=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.7.0"
      "sha256-zeLPiM5MJa9Rpt+KQD3wZ32qzREmORlcyGlKgc76fQM=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.7.0"
      "sha256-yCjlmybslu4XxHh2YMnAPg5izH5OFn+vhlcVC1/041Y=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.7.0"
      "sha256-e/Cnt9VmuYiv2bTjefIGxp/EwCQjxvNfDvjr5uhL9DU=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.7.0"
      "sha256-HpZWg8tYeYg8dwHfxrkukhhPs8fT7fotRMBdVpuWXQw=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.7.0"
      "sha256-MsLC/FeRUtLE3tE77WP1uYcewy9yy/6KZFBllyDD0P0=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.7.0"
      "sha256-Fj3v0n/jPe8Dk6AoN0AV6jQOMXO3iTpyVg/q7n/GZYY=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.7.0"
      "sha256-G2OASowQXGO+aZO3rs/mVQkamhpcXFRGuhUdJsDCugY=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.7.0"
      "sha256-IhpkDDISDM3V8bLoPZ/coORNF2RiaP/tH3IfwfcUcFQ=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.7.0"
      "sha256-7kavM49331R56b+jTP9Wr2Ck3L47HSXlxhWN3zx6fBY=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.7.0"
      "sha256-9cRSeJZANIHvYw0jQiq9miMlOoyyQbc532GZR012ZN0=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.7.0"
      "sha256-bnVdO2iVvxS5OIf77onZG/mURhiXCq9TnCVZnOnTXjQ=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.7.0"
      "sha256-Jj/YTv6RrQa5/l8N55cqS8PhileL8+2g9SM7d2ZPGjw=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.7.0"
      "sha256-PoXUp2MHUPWUT54hFcFXwsbDtCIE+ueAh0Gyk8KgWFw=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.7.0"
      "sha256-+efzRKUthVbllsHY7SHOoUW4OvZpCTfqkU6ZoTgFBuw=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.7.0"
      "sha256-UgABZPkqtuwY/S9qmYmZeiaQ0bHEqFHTxXlqUobRfQA=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.7.0"
      "sha256-2qhF5kquinBlwFSV76nTBr1w1Ji3TQl+UuozG+t3ugM=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.7.0"
      "sha256-mbmikPYw67D+qDiIuZfDCv+/dv1lupa9nAvsmWS1A2E=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.7.0"
      "sha256-k0A4HqUfoR4D2WtslVunbja0bZ/fkTmmiivUg1Z5U7g=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.7.0"
      "sha256-zsV2Nb79imZ8MzbeuDVeDy8VNc4Nl4JRn0Rxkm0cQo0=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.7.0"
      "sha256-w78lj+KbaI6Oi8tv4FFi44FI05xOS90EP5IKVct9qhA=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.7.0"
      "sha256-NOgV845NrnVhMh8pNq++Mk3+YjdKFqpo8Q45EdFfE7c=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.7.0"
      "sha256-9dLnw04eLgPW2lZ9KdP9qfndT6/mj48gohOmRFpVa+c=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.7.0"
      "sha256-zLT7wuqpOIGi2JbfD9D1+9sdPnfvGs7BETQqLCSUjMY=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.7.0"
      "sha256-s+CAKtIiRQo/CIlFSl05Qguf4jg18b02KRTPWe/NtsU=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.7.0"
      "sha256-pXEJ5Quh41XCX+Q5LFuBh3SpiD/c4/04USa7QURBOzs=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.7.0"
      "sha256-HdWai/n4XaPOFsuKZlLMMZiXOH42MmOPgDzzZab6klE=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.7.0"
      "sha256-bv4qaMc+qbdpUrGpVzxH5TdG+vlA8nP5s+vlfINtnVU=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.7.0"
      "sha256-uBuoOqboxr/hIU5iPrwNYS8VhofJ50YyAZw5h1Mnctg=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.7.0"
      "sha256-bn+T6M+U7kcwpuYnPEH3MbgbU/HDX7M3z8S2MDpofe8=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.7.0"
      "sha256-zanugixBwYpCW07zFgrpWOgmPiIivcCU2E9rDGE71Rs=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.7.0"
      "sha256-lV+xoBwmwDN43DwKSFgnDhQIOg+TCmW4p8UGzuceB5c=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.7.0"
      "sha256-az1b5MfaxOoky0LK5RmSwhjyi3wiBwiEdjtec64vVJQ=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.7.0"
      "sha256-WztQK0vAAS9+kaAbJadW7l2K+1AqjDvELA/kL4vT2oE=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.7.0"
      "sha256-vH5hQv6AMRw2Hbffty1MUjNaCkxF5s0sauZG/68Xdd8=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.7.0"
      "sha256-FWcxoAqj4/H3N+NuauCZl16sFyfIwfWOsksLYztlA60=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.7.0"
      "sha256-z6WlR/lNlKShy3rFJOhYZg8X0LuKh55BH5egM2OI5vQ=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.7.0"
      "sha256-N9AR7PVpiZu7UhRH60Bh524cNwIhD2eOeffYTgJbX6I=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.7.0"
      "sha256-MWGa8UDcfxT/hTSZoB/eh80x6os8tjPZOG3oH5hrBtI=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.7.0"
      "sha256-YMwg73zvYq+/j8gYlnOiNbJcXBG1wH4bU9AyhODxZJ8=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.7.0"
      "sha256-8Q3slnNW50o1eVFvI18TCyOZYj33kdT4hDE5GyrXZBY=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.7.0"
      "sha256-sdA/KAqDo6yVrzY2X5H1FYGwDgxB3JEsLNzbCy3tsBI=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.7.0"
      "sha256-CqvBSyY83nIYoaIn/1wAF1rM+t55y2fZZMOmu6DABZ8=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.7.0"
      "sha256-9c7lpZJt7W+Xd3FmGk8qXVhzlWW2u5KsWYoL9NHku6s=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.7.0"
      "sha256-hduCFQqtkNnX710yTisFUF3rvTMad1T0QvNC2ONyQVw=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.7.0"
      "sha256-0CtDTCrr5s18TeSeRHgXXEHmrQ0xHxrbl3zZjljaiTA=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.7.0"
      "sha256-r7P4xmMZLSU6Hf51gC5qbRl2i+bLBj0sfZwRAD4XHWY=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.7.0"
      "sha256-H3qDKntXafHonJnYsKyNsmtG8IX5kqGmLV+Xj8fsb3I=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.7.0"
      "sha256-ys91rbOAHnqGxZw37I8AjKfPsQ3+ld6egecdiae8urY=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.7.0"
      "sha256-qE8L6qG/Gf7394nLwtI4x8jHsPq1wxoqmHvxkQsV0ps=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.7.0"
      "sha256-/2d9Jhs2R2RragN21pN1y9kV6HQ85R6RseKXyntBW0k=";
}
