$token = "##TOKEN##"
$Organization = "$##OrganizationName##"

$Header = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":"+$token))}
$Type = "application/json"
$Url = "https://dev.azure.com/"+ $Organization +"/_apis/projects?api-version=6.0"

$ProjectItemHolder = (Invoke-RestMethod -Uri $Url -Headers $Header -Method GET -ContentType $Type)
$ProjectItems = ($ProjectItemHolder.value)

$sumPipeline = 0
$sumRelease = 0
foreach ($projectItem in $ProjectItems){
   
   $UrlPList = "https://dev.azure.com/" + $Organization + "/" + $projectItem.name + "/_apis/build/definitions?api-version=6.0"
   $UrlRList = "https://vsrm.dev.azure.com/" + $Organization + "/" + $projectItem.name + "/_apis/release/definitions?api-version=6.0"
   
   $ProjectPipelineHolder = (Invoke-RestMethod -Uri $UrlPList -Headers $Header -Method GET -ContentType $Type)
   $ProjectReleasePipelineHolder = (Invoke-RestMethod -Uri $UrlRList -Headers $Header -Method GET -ContentType $Type)

   $sumPipeline = $sumPipeline + $ProjectPipelineHolder.count
   $sumRelease = $sumRelease + $ProjectReleasePipelineHolder.count

   Write-Host $projectItem.name "-" $ProjectPipelineHolder.count "-" $ProjectReleasePipelineHolder.count
}

Write-Host "Total Pipeline: " $sumPipeline
Write-Host "Total Release Pipeline: " $sumRelease