{-----------------------------------------------------------------------------
 Project: Settings
 Purpose: Contains links for components shipped with Delphi 
 Created: 21.05.2008 14:40:01
 
 (c) by TheUnknownOnes
 see http://www.TheUnknownOnes.net
-----------------------------------------------------------------------------}
unit uSettingsLinksDefault;

interface

uses
  Classes,
  Controls,
  SysUtils,
  Variants,
  uSettingsBase,
  Forms,
  ComCtrls,
  TypInfo;

type

  TSettingsLinkComponent = class(TCustomSettingsComponentLink)
  published
    property Settings;
    property DefaultRootSetting;
    property OnNeedRootSetting;
    property SaveProperties;

    property Component;
  end;


//==============================================================================


  TCustomSettingsComponentLinkForm = class(TCustomSettingsComponentLink)
  protected
    FSaveWindowState: Boolean;

    procedure DoApplySettings(const ARootSetting : TSettingName); override;
    procedure DoSaveSettings(const ARootSetting : TSettingName); override;
  public
    constructor Create(AOwner: TComponent); override;

    property SaveWindowState : Boolean read FSaveWindowState write FSaveWindowState default true;
  end;


//==============================================================================


  TSettingsLinkForm = class(TCustomSettingsComponentLinkForm)
  published
    property Settings;
    property DefaultRootSetting;
    property OnNeedRootSetting;
    property SaveProperties;

    property SaveWindowState;
  end;

//==============================================================================


  TCustomSettingsComponentLinkListView = class(TCustomSettingsComponentLink)
  protected
    FSaveColumnWidth : Boolean;

    function GetListView: TListView;
    procedure SetListView(const Value: TListView);

    procedure DoApplySettings(const ARootSetting : TSettingName); override;
    procedure DoSaveSettings(const ARootSetting : TSettingName); override;
  public
    constructor Create(AOwner: TComponent); override;

    property ListView : TListView read GetListView write SetListView;

    property SaveColumnWidth : Boolean read FSaveColumnWidth write FSaveColumnWidth default true;
  end;


//==============================================================================


  TSettingsLinkListView = class(TCustomSettingsComponentLinkListView)
  published
    property Settings;
    property DefaultRootSetting;
    property OnNeedRootSetting;
    property SaveProperties;

    property ListView;
    property SaveColumnWidth;
  end;

implementation



{ TCustomSettingsComponentLinkForm }

constructor TCustomSettingsComponentLinkForm.Create(AOwner: TComponent);
begin
  inherited;

  if not (AOwner is TCustomForm) then
    raise Exception.Create('This link may only be owned by a Form');

  Component := TCustomForm(AOwner);
  FDefaultRootSetting := SettingsPathDelimiter + Component.Name;

  SaveWindowState := true;
end;

procedure TCustomSettingsComponentLinkForm.DoApplySettings(const ARootSetting : TSettingName);
var
  Form : TCustomForm;
  Value : Variant;
begin
  inherited;

  if Assigned(Component) and Assigned(Settings) then
  begin
    Form := TCustomForm(Component);

    if SaveWindowState then
    begin
      Value := Settings.GetValue(ARootSetting + SettingsPathDelimiter + 'WindowState');
      if not VarIsEmpty(Value) then
        Form.WindowState := TWindowState(Value);
    end;
  end;
end;

procedure TCustomSettingsComponentLinkForm.DoSaveSettings(const ARootSetting : TSettingName);
var
  Form : TCustomForm;
begin
  inherited;

  if Assigned(Component) and Assigned(Settings) then
  begin
    Form := TCustomForm(Component);

    if SaveWindowState then
      Settings.SetValue(ARootSetting + SettingsPathDelimiter + 'WindowState', Integer(Form.WindowState));
  end;
end;


//==============================================================================


{ TCustomSettingsComponentLinkListView }

constructor TCustomSettingsComponentLinkListView.Create(AOwner: TComponent);
begin
  inherited;

  FSaveColumnWidth := true;
end;

procedure TCustomSettingsComponentLinkListView.DoApplySettings(const ARootSetting : TSettingName);
var
  ListView : TListView;
  Value : Variant;
  Col : TListColumn;
  idx : Integer;
const
  ColSettingNamePattern = 'Column%.4d';
begin
  inherited;

  if Assigned(Component) and Assigned(Settings) then
  begin
    ListView := TListView(Component);

    for idx := 0 to ListView.Columns.Count - 1 do
    begin
      Col := ListView.Columns[idx];

      if FSaveColumnWidth then
      begin
        Value := Settings.GetValue(ARootSetting + SettingsPathDelimiter +
                                    Format(ColSettingNamePattern, [idx]) +
                                    SettingsPathDelimiter + 'Width');

        if not VarIsEmpty(Value) then
          Col.Width := Value;
      end;
    end;
  end;
end;

procedure TCustomSettingsComponentLinkListView.DoSaveSettings(const ARootSetting : TSettingName);
var
  ListView : TListView;
  Col : TListColumn;
  idx : Integer;
const
  ColSettingNamePattern = 'Column%.4d';
begin
  inherited;

  if Assigned(Component) and Assigned(Settings) then
  begin
    ListView := TListView(Component);

    for idx := 0 to ListView.Columns.Count - 1 do
    begin
      Col := ListView.Columns[idx];

      if FSaveColumnWidth then
      begin
        Settings.SetValue(ARootSetting + SettingsPathDelimiter +
                           Format(ColSettingNamePattern, [idx]) +
                           SettingsPathDelimiter + 'Width', Col.Width);
      end;
    end;
  end;
end;


function TCustomSettingsComponentLinkListView.GetListView: TListView;
begin
  Result := TListView(Component);
end;

procedure TCustomSettingsComponentLinkListView.SetListView(
  const Value: TListView);
begin
  Component := Value;
end;

end.
