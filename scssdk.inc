{$Macro On}

{$ifndef SCSSDK_INC}
  {$define SCSSDK_INC}
  {$if defined(CPUX86_64)}
    {$define SCS_ARCHITECTURE_x64}
    {$define SCS_PF_U64:='lu'}
    {$define SCS_PF_S64:='ld'}
  {$Else}
    {$define SCS_ARCHITECTURE_x86}
    {$define SCS_PF_U64:='llu'}
    {$define SCS_PF_S64:='lld'}
  {$EndIf}
{$EndIf}
