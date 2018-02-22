unit Form;

{$mode objfpc}{$H+}

interface

uses
  User, Group, UserGroup, Chat, UserChat, Message, Invitation, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    accountButton: TButton;
    accountFirstNameEdit: TEdit;
    accountLastNameEdit: TEdit;
    accountUsernameEdit: TEdit;
    accountUpdateButton: TButton;
    accountNewPasswordEdit: TEdit;
    accountPasswordEdit: TEdit;
    backButton: TButton;
    chatNewMessageButton: TButton;
    chatInviteMemberButton: TButton;
    groupCreateChatButton: TButton;
    groupInviteMemberButton: TButton;
    editGroupUpdateButton: TButton;
    editGroupDescriptionEdit: TEdit;
    editGroupNameEdit: TEdit;
    editChatUpdateButton: TButton;
    createGrupCreateButton: TButton;
    createChatCreateButton: TButton;
    createChatNameEdit: TEdit;
    createChatGroupEdit: TEdit;
    createGroupNameEdit: TEdit;
    createGroupDescriptionEdit: TEdit;
    editChatGroupEdit: TEdit;
    editChatNameEdit: TEdit;
    homeCreateGroupButton: TButton;
    homeCreateChatButton: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    groupNameLabel: TLabel;
    groupDescriptionLabel: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    chatNameLabel: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
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
    procedure accountButtonClick(Sender: TObject);
    procedure accountUpdateButtonClick(Sender: TObject);
    procedure backButtonClick(Sender: TObject);
    procedure chatInviteMemberButtonClick(Sender: TObject);
    procedure chatNewMessageButtonClick(Sender: TObject);
    procedure createChatCreateButtonClick(Sender: TObject);
    procedure createGrupCreateButtonClick(Sender: TObject);
    procedure editChatUpdateButtonClick(Sender: TObject);
    procedure editGroupUpdateButtonClick(Sender: TObject);
    procedure groupCreateChatButtonClick(Sender: TObject);
    procedure groupInviteMemberButtonClick(Sender: TObject);
    procedure homeCreateChatButtonClick(Sender: TObject);
    procedure homeCreateGroupButtonClick(Sender: TObject);
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
    referrer: TView;
    parameter: integer;
  protected
    function setCurrent(c: string): string;
    function setReferrer(r: TView): TView;
    function setParameter(p: integer): integer;
  public
    constructor create(c: string; r: TView; p: integer);
    function switch(c: string; p: integer): boolean;
    function back(): boolean;
    function getTabIndexFor(c: string): integer;
    function initialize(): boolean;
    function getCurrent(): string;
    function getReferrer(): TView;
    function getParameter(): integer;
    procedure openGroupButtonClick(Sender: TObject);
    procedure openChatButtonClick(Sender: TObject);
  end;

var
  Form1: TForm1;
  currentView: TView;
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
    accountButton.Visible := false;
    signoutButton.Visible := false;
  end
  else
  begin
    userLabel.Caption := 'Logged in as:';
    usernameLabel.Caption := '@' + currentUser.getUsername();
    loginButton.Visible := false;
    signupButton.Visible := false;
    accountButton.Visible := true;
    signoutButton.Visible := true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ShowTabs := false;
  currentView.switch('Login', 0);
end;

procedure TForm1.loginButtonClick(Sender: TObject);
begin
  currentView.switch('Login', 0);
end;

procedure TForm1.loginLoginButtonClick(Sender: TObject);
begin
  currentUser := TUser.login(loginUsernameEdit.Text, loginPasswordEdit.Text);
  if currentUser = nil then
    showMessage('Invalid username or password')
  else
  begin
    loginUsernameEdit.Text := '';
    loginPasswordEdit.Text := '';
    updateTitlebar();
    currentView.switch('Home', 0);
  end;
end;

procedure TForm1.signupButtonClick(Sender: TObject);
begin
  currentView.switch('Signup', 0);
end;

procedure TForm1.signupSignupButtonClick(Sender: TObject);
begin
  currentUser := TUser.signup(signupUsernameEdit.Text, signupFirstNameEdit.Text, signupLastNameEdit.Text, signupPasswordEdit.Text);
  if currentUser = nil then
    showMessage('User with this username already exists')
  else
  begin
    signupFirstNameEdit.Text := '';
    signupLastNameEdit.Text := '';
    signupUsernameEdit.Text := '';
    signupPasswordEdit.Text := '';
    updateTitlebar();
    currentView.switch('Home', 0);
  end;
end;

procedure TForm1.signoutButtonClick(Sender: TObject);
begin
  currentUser := nil;
  updateTitlebar();
  currentView.switch('Login', 0);
end;

procedure TForm1.accountButtonClick(Sender: TObject);
begin
  currentView.switch('Account', 0);
end;

procedure TForm1.accountUpdateButtonClick(Sender: TObject);
var newPassword: string;
begin
  newPassword := accountNewPasswordEdit.Text;
  if accountNewPasswordEdit.Text = '' then
    newPassword := currentUser.getPassword();
  if currentUser.update(accountPasswordEdit.Text, accountUsernameEdit.Text, accountFirstNameEdit.Text, accountLastNameEdit.Text, newPassword) = nil then
    showMessage('Wrong password')
  else
  begin
    accountFirstNameEdit.Text := '';
    accountLastNameEdit.Text := '';
    accountUsernameEdit.Text := '';
    accountNewPasswordEdit.Text := '';
    accountPasswordEdit.Text := '';
    currentView.switch('Home', 0);
  end;
end;

procedure TForm1.backButtonClick(Sender: TObject);
begin
  currentView.back();
end;

procedure TForm1.chatInviteMemberButtonClick(Sender: TObject);
begin
  // currentView.switch('New invitation', findChatByName(chatNameLabel.caption)[0].getId());
end;

procedure TForm1.chatNewMessageButtonClick(Sender: TObject);
var co: string;
begin
  InputQuery('New message', 'Write something up ...', TRUE, co);
  TMessage.create(findChat(currentView.getParameter())[0], currentUser, co);
  currentView.switch('Chat', currentView.getParameter());
end;

procedure TForm1.createChatCreateButtonClick(Sender: TObject);
var chat: TChat; group: TGroup;
begin
  if length(findGroupByName(createChatGroupEdit.Text)) > 0 then
    if findGroupByName(createChatGroupEdit.Text)[0].getUserId = currentUser.getId() then
      group := findGroupByName(createChatGroupEdit.Text)[0]
    else
      showMessage('You do not own this group')
  else
    group := nil;
  if ( length(createChatGroupEdit.Text) > 0 ) and ( group = nil ) then
    showMessage('Group does not exist')
  else
  begin
    chat := TChat.create(currentUser, group, createChatNameEdit.Text);
    TUserChat.create(currentUser, chat);
    createChatNameEdit.Text := '';
    createChatGroupEdit.Text := '';
    currentView.switch('Chat', chat.getId());
  end;
end;

procedure TForm1.createGrupCreateButtonClick(Sender: TObject);
var group: TGroup;
begin
  group := TGroup.create(currentUser, createGroupNameEdit.Text, createGroupDescriptionEdit.Text);
  TUserGroup.create(currentUser, group);
  createGroupNameEdit.Text := '';
  createGroupDescriptionEdit.Text := '';
  currentView.switch('Group', group.getId());
end;

procedure TForm1.editChatUpdateButtonClick(Sender: TObject);
var chat: TChat; group: TGroup;
begin
  if length(findGroupByName(editChatGroupEdit.Text)) > 0 then
    if findGroupByName(editChatGroupEdit.Text)[0].getUserId = currentUser.getId() then
      group := findGroupByName(editChatGroupEdit.Text)[0]
    else
      showMessage('You do not own this group')
  else
    group := nil;
  if ( length(editChatGroupEdit.Text) > 0 ) and ( group <> nil ) then
    showMessage('Group does not exist')
  else
  begin
    chat := findChat(currentView.getParameter())[0].update(group, editChatNameEdit.Text);
    editChatNameEdit.Text := '';
    editChatGroupEdit.Text := '';
    currentView.switch('Chat', chat.getId());
  end;
end;

procedure TForm1.editGroupUpdateButtonClick(Sender: TObject);
var group: TGroup;
begin
  group := findGroup(currentView.getParameter())[0].update(editGroupNameEdit.Text, editGroupDescriptionEdit.Text);
  editGroupNameEdit.Text := '';
  editGroupDescriptionEdit.Text := '';
  currentView.switch('Group', group.getId());
end;

procedure TForm1.groupCreateChatButtonClick(Sender: TObject);
begin
  currentView.switch('Create chat', findGroupByName(groupNameLabel.caption)[0].getId());
end;

procedure TForm1.groupInviteMemberButtonClick(Sender: TObject);
begin
  currentView.switch('New invitation', findGroupByName(groupNameLabel.caption)[0].getId());
end;

procedure TForm1.homeCreateChatButtonClick(Sender: TObject);
begin
  currentView.switch('Create chat', 0);
end;

procedure TForm1.homeCreateGroupButtonClick(Sender: TObject);
begin
  currentView.switch('Create group', 0);
end;

{ TView }

constructor TView.create(c: string; r: TView; p: integer);
begin
  inherited create();
  self.setCurrent(c);
  self.setReferrer(r);
  self.setParameter(p);
end;

function TView.switch(c: string; p: integer): boolean;
begin
  currentView := TView.create(c, currentView, p);
  if currentView.getReferrer() <> nil then
    Form1.backButton.Enabled := true;
  result := currentView.initialize();
end;

function TView.back(): boolean;
begin
  currentView := self.getReferrer();
  if currentView.getReferrer() <> nil then
    Form1.backButton.Enabled := true
  else
    Form1.backButton.Enabled := false;
  result := currentView.initialize();
end;

function TView.getTabIndexFor(c: string): integer;
begin
  case c of
    'Home': result := 0;
    'Account': result := 1;
    'Login': result := 2;
    'Signup': result := 3;
    'Group': result := 4;
    'Chat': result := 5;
    'Create chat': result := 6;
    'Create group': result := 7;
    'Edit chat': result := 8;
    'Edit group': result := 9;
    'Invitations': result := 10;
    'New invitation': result := 11;
  end;
end;

function TView.initialize(): boolean;
var userGroups: TGroupArray; userChats: TChatArray; groupChats: TChatArray; chatMessages: TMessageArray; groupUserGroups: TUserGroupArray; chatUserChats: TUserChatArray; group: TGroup; chat: TChat; i: integer; panel: TPanel; text: TLabel; button: TButton;
begin
  if (currentUser = nil) and ( (self.getCurrent() = 'Home') or (self.getCurrent() = 'Account') or (self.getCurrent() = 'Group') or (self.getCurrent() = 'Chat') or (self.getCurrent() = 'Create chat') or (self.getCurrent() = 'Create group') or (self.getCurrent() = 'Edit chat') or (self.getCurrent() = 'Edit group') or (self.getCurrent() = 'Invitations') or (self.getCurrent() = 'New invitation') ) then
  begin
    currentView.switch('Login', 0);
    result := false;
    exit;
  end;
  if (currentUser <> nil) and ( (self.getCurrent() = 'Login') or (self.getCurrent() = 'Signup') ) then
  begin
    currentView.switch('Home', 0);
    result := false;
    exit;
  end;
  if self.getCurrent() = 'Home' then
  begin
    userGroups := findGroupByUser(currentUser);
    for i:=0 to length(userGroups) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet1;
      panel.left := 40;
      panel.top := 125 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := userGroups[i].getName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := userGroups[i].getDescription();
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 60;
      button.caption := 'Open';
      button.HelpContext := userGroups[i].getId();
      button.OnClick := @openGroupButtonClick;
    end;
    userChats := findChatByUser(currentUser);
    for i:=0 to length(userChats) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet1;
      panel.left := 350;
      panel.top := 125 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := userChats[i].getName();
      if ( userChats[i].getGroupId() <> 0) and ( length(findGroup(userChats[i].getGroupId())) > 0 ) then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 37;
        text.caption := findGroup(userChats[i].getGroupId())[0].getName();
      end;
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 60;
      button.caption := 'Open';
      button.HelpContext := userChats[i].getId();
      button.OnClick := @openChatButtonClick;
    end;
  end;
  if self.getCurrent() = 'Group' then
  begin
    group := findGroup(self.getParameter())[0];
    Form1.groupNameLabel.caption := group.getName();
    Form1.groupDescriptionLabel.caption := group.getDescription();
    groupChats := findChatByGroup(group);
    for i:=0 to length(groupChats) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet5;
      panel.left := 40;
      panel.top := 215 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := groupChats[i].getName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := group.getName();
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 60;
      button.caption := 'Open';
      button.HelpContext := groupChats[i].getId();
      button.OnClick := @openChatButtonClick;
    end;
    groupUserGroups := findUserGroupByGroup(group);
    for i:=0 to length(groupUserGroups) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet5;
      panel.left := 350;
      panel.top := 215 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(groupUserGroups[i].getUserId())[0].getFirstName() + ' ' + findUser(groupUserGroups[i].getUserId())[0].getLastName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := '@' + findUser(groupUserGroups[i].getUserId())[0].getUsername();
      if findUser(groupUserGroups[i].getUserId())[0].getId() = group.getUserId() then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 60;
        text.caption := 'Admin';
      end;
    end;
  end;
  if self.getCurrent() = 'Chat' then
  begin
    chat := findChat(self.getParameter())[0];
    Form1.chatNameLabel.caption := chat.getName();
    chatMessages := findMessageByChat(chat);
    for i:=0 to length(chatMessages) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet6;
      panel.left := 40;
      panel.top := 215 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(chatMessages[i].getUserId())[0].getFirstName + ' ' + findUser(chatMessages[i].getUserId())[0].getLastName + ' (@' + findUser(chatMessages[i].getUserId())[0].getUsername + ')';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := chatMessages[i].getContent();
    end;
    chatUserChats := findUserChatByChat(chat);
    for i:=0 to length(chatUserChats) - 1 do
    begin
      panel := TPanel.create(Form1);
      panel.parent := Form1.TabSheet6;
      panel.left := 350;
      panel.top := 215 + (i * 100);
      panel.height := 100;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 16;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(chatUserChats[i].getUserId())[0].getFirstName() + ' ' + findUser(chatUserChats[i].getUserId())[0].getLastName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := '@' + findUser(chatUserChats[i].getUserId())[0].getUsername();
      if findUser(chatUserChats[i].getUserId())[0].getId() = chat.getUserId() then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 60;
        text.caption := 'Admin';
      end;
    end;
  end;
  if self.getCurrent() = 'Create chat' then
  begin
    if self.getParameter() <> 0 then
    begin
      group := findGroup(self.getParameter)[0];
      Form1.createChatGroupEdit.text := group.getName();
    end;
  end;
  if self.getCurrent() = 'Account' then
  begin
    Form1.accountFirstNameEdit.Text := currentUser.getFirstName();
    Form1.accountLastNameEdit.Text := currentUser.getLastName();
    Form1.accountUsernameEdit.Text := currentUser.getUsername();
  end;
  Form1.PageControl1.TabIndex := getTabIndexFor(self.getCurrent());
  result := true;
end;

function TView.getCurrent(): string;
begin
  result := self.current;
end;

function TView.getReferrer(): TView;
begin
  result := self.referrer;
end;

function TView.getParameter(): integer;
begin
  result := self.parameter;
end;

function TView.setCurrent(c: string): string;
begin
  self.current := c;
  result := self.getCurrent();
end;

function TView.setReferrer(r: TView): TView;
begin
  self.referrer := r;
  result := self.getReferrer();
end;

function TView.setParameter(p: integer): integer;
begin
  self.parameter := p;
  result := self.getParameter();
end;

procedure TView.openGroupButtonClick(Sender: TObject);
begin
with Sender as TButton do
begin
  currentView.switch('Group', HelpContext);
end;
end;

procedure TView.openChatButtonClick(Sender: TObject);
begin
with Sender as TButton do
begin
  currentView.switch('Chat', HelpContext);
end;
end;

initialization

randomize();

end.
