object FOGantt: TFOGantt
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = ' '
  ClientHeight = 788
  ClientWidth = 1386
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  Visible = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object panelHintergrund: TPanel
    Left = 0
    Top = 0
    Width = 1386
    Height = 788
    Align = alClient
    Caption = 'panelHintergrund'
    TabOrder = 1
    object panelOben: TPanel
      Left = 1
      Top = 1
      Width = 1384
      Height = 65
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        1384
        65)
      object BTNTagesansicht: TButton
        Left = 207
        Top = 27
        Width = 97
        Height = 33
        Caption = 'Tagesansicht'
        TabOrder = 2
        OnClick = BTNTagesansichtClick
      end
      object BTNMonatsansicht: TButton
        Left = 104
        Top = 27
        Width = 97
        Height = 33
        Caption = 'Monatsansicht'
        TabOrder = 1
        OnClick = BTNMonatsansichtClick
      end
      object BTNJahresansicht: TButton
        Left = 1
        Top = 26
        Width = 97
        Height = 33
        Caption = 'Jahresansicht'
        TabOrder = 0
        OnClick = BTNJahresansichtClick
      end
      object BTNEinstellungen: TButton
        Left = 1175
        Top = 32
        Width = 97
        Height = 32
        Align = alCustom
        Anchors = [akTop, akRight]
        Caption = 'Einstellungen'
        TabOrder = 4
        OnClick = BTNEinstellungenClick
      end
      object BTNBeenden: TButton
        Left = 1278
        Top = 32
        Width = 97
        Height = 32
        Anchors = [akTop, akRight]
        Caption = 'Beenden'
        TabOrder = 5
        OnClick = BTNBeendenClick
      end
      object EDDatum: TMaskEdit
        Left = 1
        Top = 0
        Width = 97
        Height = 21
        EditMask = '!90/90/00;1; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        TabOrder = 3
        Text = '  .  .  '
      end
      object PJahresschild: TPanel
        Left = 1175
        Top = 0
        Width = 200
        Height = 32
        Anchors = [akTop, akRight]
        BevelInner = bvRaised
        Color = clSkyBlue
        ParentBackground = False
        TabOrder = 6
      end
      object BTNSpeichern: TButton
        Left = 328
        Top = 27
        Width = 89
        Height = 32
        Caption = 'Speichern'
        TabOrder = 7
        OnClick = BTNSpeichernClick
      end
    end
    object panelUnten: TPanel
      Left = 1
      Top = 625
      Width = 1384
      Height = 162
      Align = alBottom
      Caption = 'panelUnten'
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 1382
        Height = 160
        Align = alClient
        BorderStyle = bsNone
        DataSource = DataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = DBGrid1CellClick
        OnDrawColumnCell = DBGrid1DrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'KDNR'
            Title.Caption = 'Kunden Nr'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'KDNAME'
            Title.Caption = 'Kunden Name'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AUFTRNR'
            Title.Caption = 'Auftragsnummer'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ABUHR'
            Title.Caption = 'Uhrzeit Anfang'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BISUHR'
            Title.Caption = 'Uhrzeit Ende'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ABDATUM'
            Title.Caption = 'Beginn Datum'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BISDATUM'
            Title.Caption = 'End Datum'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENGE'
            Title.Caption = 'Anzahl'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GESLMENGE'
            Title.Caption = 'Gel. Anzahl'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PERSNR'
            Title.Caption = 'Personen Nr'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'H1'
            Title.Caption = 'Info Nr1'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'H2'
            Title.Caption = 'Info Nr2'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'H3'
            Title.Caption = 'Info Nr3'
            Visible = True
          end>
      end
    end
    object panelMitte: TPanel
      Left = 1
      Top = 66
      Width = 1384
      Height = 559
      Align = alClient
      Caption = 'panelMitte'
      TabOrder = 2
      object ScrollGanttbox: TScrollBox
        Left = 1
        Top = 1
        Width = 1382
        Height = 557
        HorzScrollBar.ButtonSize = 1
        HorzScrollBar.Tracking = True
        HorzScrollBar.Visible = False
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
    end
  end
  object NeuScrollbar: TScrollBar
    Left = 56
    Top = 361
    Width = 976
    Height = 33
    PageSize = 20
    TabOrder = 0
    Visible = False
    OnScroll = NeuScrollbarScroll
  end
  object FDMemTable1: TFDMemTable
    Filter = 'stati='#39'1'#39
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 168
    Top = 672
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 314
    Top = 499
  end
  object MainMenu1: TMainMenu
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Left = 449
    Top = 9
    object aaaa1: TMenuItem
      Caption = 'Hilfe'
      object Anleitung: TMenuItem
        Caption = 'Anleitung'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Kontakt: TMenuItem
        Caption = 'Kontakt'
      end
    end
  end
  object TBLQuery: TFDQuery
    FieldOptions.AutoCreateMode = acCombineAlways
    Indexes = <
      item
        Active = True
        Name = 'artsxs'
        Fields = 'SACHNR'
      end
      item
        Active = True
        Name = 'artsxb'
      end>
    IndexesActive = False
    FetchOptions.AssignedValues = [evItems, evRowsetSize, evAutoClose, evRecordCountMode, evCursorKind, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.CountUpdatedRecords = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.CheckUpdatable = False
    SQL.Strings = (
      'select Menge ,  geslmenge , liefdat , LOGS  from aufdb2')
    Left = 24
    Top = 160
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Program Files\HeidiSQL\libmysql-6.1.dll'
    Left = 32
    Top = 256
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Database=cimoswin'
      'Server=127.0.0.1'
      'Password=23rdmwcc'
      'DriverID=MySQL')
    FetchOptions.AssignedValues = [evDetailDelay]
    FetchOptions.DetailDelay = 100
    TxOptions.Isolation = xiRepeatableRead
    TxOptions.DisconnectAction = xdRollback
    LoginPrompt = False
    Left = 24
    Top = 32
  end
end
