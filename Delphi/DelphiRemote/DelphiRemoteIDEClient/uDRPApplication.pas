unit uDRPApplication;

interface

uses
  uDelphiRemoteIDEClientPlugin;

type
  TDRPApplication = class(TDelphiRemoteIDEClientPlugin)
  protected
    function GetHelpText : string; override;
  public
    procedure Close;
  end;

implementation

uses uDelphiRemoteIDEClient, Forms;

var
  DRPApplication: TDRPApplication;

{ TDRPApplication }

procedure TDRPApplication.Close;
begin
  Application.MainForm.Close;
end;

function TDRPApplication.GetHelpText: string;
begin
  Result:='Lustiges App Objekt';
end;

initialization
  DRPApplication:=TDRPApplication.Create;
  GlobalDelphiRemoteIDEClient.RegisterChild('Application', DRPApplication);

finalization
  GlobalDelphiRemoteIDEClient.UnregisterChild(DRPApplication);
  DRPApplication.Free;

end.
