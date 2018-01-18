unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Unit2, Unit3, Unit4, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    signoutButton: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    signupSignupButton: TButton;
    signupPasswordEdit: TEdit;
    signupUsernameEdit: TEdit;
    signupLastNameEdit: TEdit;
    signupFirstNameEdit: TEdit;
    loginUsernameEdit: TEdit;
    loginPasswordEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    loginLoginButton: TButton;
    userLabel: TLabel;
    usernameLabel: TLabel;
    loginButton: TButton;
    signupButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    procedure signoutButtonClick(Sender: TObject);
    procedure updateTitlebar();
    procedure FormCreate(Sender: TObject);
    procedure loginButtonClick(Sender: TObject);
    procedure loginLoginButtonClick(Sender: TObject);
    procedure signupButtonClick(Sender: TObject);
    procedure signupSignupButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  { TView }

  TView = class
  private
    current: string;
  protected
    function setCurrent(c: string): string;
  public
    constructor create();
    function switch(n: string): string;
    function getTabIndexFor(n: string): integer;
    function getCurrent(): string;
  end;

var
  Form1: TForm1;
  view: TView;
  currentUser: TUser;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.updateTitlebar();
begin
  if currentUser = nil then
  begin
     userLabel.Caption := 'Not signed in yet ...';
     usernameLabel.Caption := '';
     loginButton.Visible := true;
     signupButton.Visible := true;
     signoutButton.Visible := false;
  end
  else
  begin
     userLabel.Caption := 'Logged in as:';
     usernameLabel.Caption := '@' + currentUser.getUsername();
     loginButton.Visible := false;
     signupButton.Visible := false;
     signoutButton.Visible := true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ShowTabs := false;
  view := TView.create();
end;

procedure TForm1.loginButtonClick(Sender: TObject);
begin
  view.switch('Login');
end;

procedure TForm1.loginLoginButtonClick(Sender: TObject);
begin
  currentUser := TUser.login(loginUsernameEdit.Text, loginPasswordEdit.Text);
  loginUsernameEdit.Text := '';
  loginPasswordEdit.Text := '';
  if currentUser = nil then
     showMessage('Invalid username or password')
  else
  begin
     updateTitlebar();
     view.switch('Home');
  end;
end;

procedure TForm1.signupButtonClick(Sender: TObject);
begin
  view.switch('Signup');
end;

procedure TForm1.signupSignupButtonClick(Sender: TObject);
begin
  currentUser := TUser.signup(signupUsernameEdit.Text, signupFirstNameEdit.Text, signupLastNameEdit.Text, signupPasswordEdit.Text);
  signupFirstNameEdit.Text := '';
  signupLastNameEdit.Text := '';
  signupUsernameEdit.Text := '';
  signupPasswordEdit.Text := '';
  if currentUser = nil then
     showMessage('User with this username already exists')
  else
  begin
     updateTitlebar();
     view.switch('Home');
  end;
end;

procedure TForm1.signoutButtonClick(Sender: TObject);
begin
  currentUser := nil;
  updateTitlebar();
  view.switch('Login');
end;

{ TView }

constructor TView.create();
begin
  inherited create();
  self.setCurrent('Login');
end;

function TView.switch(n: string): string;
begin
  Form1.PageControl1.TabIndex := getTabIndexFor(n);
  self.setCurrent(n);
  result := self.getCurrent();
end;

function TView.getTabIndexFor(n: string): integer;
begin
  case n of
    'Home': result := 0;
    'Account': result := 1;
    'Login': result := 2;
    'Signup': result := 3;
    'Group': result := 4;
    'Chat': result := 5;
    'Create char': result := 6;
    'Create group': result := 7;
    'Edit chat': result := 8;
    'Edit group': result := 9;
    'Invitations': result := 10;
    'New invitation': result := 11;
  end;
end;

function TView.getCurrent(): string;
begin
  result := self.current;
end;

function TView.setCurrent(c: string): string;
begin
  self.current := c;
  result := self.getCurrent();
end;

end.

