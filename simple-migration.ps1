
function Get-ArrayReversed {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]
        $InputArray
    )

    process {
        return $(
            $InputArray |
            Sort-Object `
                -Property: { (--$script:i) }
        )

    }
}

function Merge-Csv {
    [CmdletBinding()]
    param(
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $InputPath,

        # Specifies a path to one location.
        [Parameter(Mandatory,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Path to one location.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $OutputPath
    )
  
    begin {
        $InputData = @()
    }
  
    process {
        $InputData += Import-Csv `
            -Path:$InputPath
    }
  
    end {
        $(Merge-Data `
                -InputArray:$InputData
        ) |
        Export-Csv `
            -Path:$OutputPath
    }
}
  
function Merge-Data {
    [CmdletBinding()]
    param (
        # The data to merge into a unique set of data
        [Parameter(Mandatory)]
        [array]
        $InputArray,

        # The name of the Unique Property
        [Parameter()]
        [string]
        $UniqueProperty = "ID"
    )
    
    process {
        return $(
            $(
                Get-ArrayReversed `
                    -InputArray:$InputData
            ) |
            Sort-Object `
                -Property:$UniqueProperty `
                -Unique
        ) 
    }
}
