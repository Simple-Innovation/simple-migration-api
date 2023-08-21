BeforeAll {
    Import-Module `
        -Name:./simple-migration.ps1 `
        -Force
}

Describe 'Get-ArrayReversed' {
    It 'reverses a two object array' {
        $InputData = @(
            [PSCustomObject]@{
                ID = 0
            }
            [PSCustomObject]@{
                ID = 1
            }
        )

        $OutputData = Get-ArrayReversed `
            -InputArray:$InputData
            
        $OutputData.Count |
        Should -Be 2

        $($OutputData |
            Select-Object `
                -First:1).ID |
        Should -Be 1

        $($OutputData |
            Select-Object `
                -Last:1).ID |
        Should -Be 0
    }
}

Describe 'Merge-Csv' {
    It 'imports a single file' {
        Merge-Csv `
            -InputPath:"./_test/data-000.csv" `
            -OutputPath:"./_test/data.csv"

        $OutputData = Import-Csv `
            -Path:"./_test/data.csv"

        $OutputData.Count |
        Should -Be 1

        $(
            $OutputData |
            Select-Object `
                -First:1
        ).Value |
        Should -Be "000"
    }

    It 'imports two files' {
        Merge-Csv `
            -InputPath:@(
            "./_test/data-000.csv"
            "./_test/data-001.csv"
        ) `
            -OutputPath:"./_test/data.csv"

        $OutputData = Import-Csv `
            -Path:"./_test/data.csv"

        $OutputData.Count |
        Should -Be 1

        $(
            $OutputData |
            Select-Object `
                -First:1
        ).Value |
        Should -Be "001"
    }
}

Describe 'Merge-Data' {
    It 'returns the lastest object' {
        $InputData = @(
            [PSCustomObject]@{
                ID    = 0
                Value = "0"
            }
            [PSCustomObject]@{
                ID    = 0
                Value = "1"
            }
        )

        $OutputData = Merge-Data `
            -InputArray:$InputData

        $OutputData.Count |
        Should -Be 1

        $(
            $OutputData |
            Select-Object `
                -First:1
        ).Value |
        Should -Be "1"
    }
}
