try {
    $response = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lavtech/SyncroMSP/main/RMM/cpu_list"
    if ($response -is [String]) {
        $response = $response | ConvertFrom-Json
    }

    foreach ($cpu in $response.AMD) {
        Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
    }

    foreach ($cpu in $response.Intel) {
        Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
    }
} catch {
    Write-Error "Error fetching or parsing data: $_"
}
