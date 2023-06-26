tableextension 50114 ZYItemExt extends Item
{
    fields
    {
        field(50101; "Large Text"; Blob)
        {
            Caption = 'Large Text';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50114 ZYItemCardExt extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field(LargeText; LargeText)
            {
                Caption = 'Large Text';
                ApplicationArea = All;
                MultiLine = true;
                ShowCaption = false;

                trigger OnValidate()
                begin
                    SetLargeText(LargeText);
                end;
            }
        }
    }
    
    var
        LargeText: Text;

    trigger OnAfterGetRecord()
    begin
        LargeText := GetLargeText();
    end;

    procedure SetLargeText(NewLargeText: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Large Text");
        Rec."Large Text".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(LargeText);
        Rec.Modify();
    end;

    procedure GetLargeText() NewLargeText: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields("Large Text");
        Rec."Large Text".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("Large Text")));
    end;
}
