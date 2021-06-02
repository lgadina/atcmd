unit scsThread;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, scsData, lNet;

type

  { TscsDataThread }

  TscsDataThread = class(TThread)
  private
    FTelemetryServer: TLTcp;
    FData: TEUT2Data;
  protected
    procedure DoOnTelemetryServerConnect(aSocket: TLSocket);
  protected
    procedure Execute; override;
  public
    constructor Create(AData: TEUT2Data);
    destructor Destroy; override;
  end;

implementation

uses scssdk;

{ TscsDataThread }

procedure TscsDataThread.DoOnTelemetryServerConnect(aSocket: TLSocket);
begin
  FTelemetryServer.SendMessage('Telemetry server 0.1'#13#10, aSocket);
end;

procedure TscsDataThread.Execute;
var S: String;
    n: integer;
begin
  FData.params.common.log(SCS_LOG_TYPE_message, 'enter to main plugin thread');
  repeat
    sleep(50);
    FTelemetryServer.CallAction;
    if FData.Changed then
     begin
       S := FData.AsString;;
       //FData.params.common.log(SCS_LOG_TYPE_message, scs_string_t(s));
       FTelemetryServer.IterReset;
       while FTelemetryServer.IterNext do
         begin
           n := FTelemetryServer.SendMessage(s+#13#10);
         end;
     end;
  until Terminated;
  FTelemetryServer.Disconnect(true);
  FData := nil;
end;

constructor TscsDataThread.Create(AData: TEUT2Data);
begin
  FData := AData;
  FData.params.common.log(SCS_LOG_TYPE_message, 'create plugin thread');
  FTelemetryServer := TLTcp.Create(nil);
  FTelemetryServer.ReuseAddress:=true;
  FTelemetryServer.OnConnect:=@DoOnTelemetryServerConnect;
  if FTelemetryServer.Listen(31780) then
    FData.params.common.log(SCS_LOG_TYPE_message, scs_string_t('create telemetry server at '+IntToStr(FTelemetryServer.Port)));
  inherited Create(True);
  Resume;
  FData.params.common.log(SCS_LOG_TYPE_message, 'resume plugin thread');
end;

destructor TscsDataThread.Destroy;
begin
  FreeAndNil(FTelemetryServer);
  inherited Destroy;
end;

end.

