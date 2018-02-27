unit Form;

{$mode objfpc}{$H+}

interface

uses
  User, Group, UserGroup, Chat, UserChat, Message, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
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
    chatEditButton: TButton;
    groupEditButton: TButton;
    newGroupInvitationIviteButton: TButton;
    newGroupInvitationUsernameEdit: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    newChatInvitationInviteButton: TButton;
    chatNewMessageButton: TButton;
    chatInviteMemberButton: TButton;
    newChatInvitationUsernameEdit: TEdit;
    groupCreateChatButton: TButton;
    groupInviteMemberButton: TButton;
    editGroupUpdateButton: TButton;
    editGroupDescriptionEdit: TEdit;
    editGroupNameEdit: TEdit;
    editChatUpdateButton: TButton;
    createGroupCreateButton: TButton;
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
    ScrollBox1: TScrollBox;
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
    TabSheet12: TTabSheet;
    TabSheet11: TTabSheet;
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
    procedure chatEditButtonClick(Sender: TObject);
    procedure chatInviteMemberButtonClick(Sender: TObject);
    procedure chatNewMessageButtonClick(Sender: TObject);
    procedure createChatCreateButtonClick(Sender: TObject);
    procedure createGroupCreateButtonClick(Sender: TObject);
    procedure editChatUpdateButtonClick(Sender: TObject);
    procedure editGroupUpdateButtonClick(Sender: TObject);
    procedure groupCreateChatButtonClick(Sender: TObject);
    procedure groupEditButtonClick(Sender: TObject);
    procedure groupInviteMemberButtonClick(Sender: TObject);
    procedure homeCreateChatButtonClick(Sender: TObject);
    procedure homeCreateGroupButtonClick(Sender: TObject);
    procedure newChatInvitationInviteButtonClick(Sender: TObject);
    procedure newGroupInvitationIviteButtonClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
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
    procedure openButtonClick(Sender: TObject);
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

procedure TForm1.chatEditButtonClick(Sender: TObject);
begin
  currentView.switch('Edit chat', currentView.getParameter());
end;

procedure TForm1.chatInviteMemberButtonClick(Sender: TObject);
begin
  currentView.switch('New chat invitation', currentView.getParameter());
end;

procedure TForm1.chatNewMessageButtonClick(Sender: TObject);
var co: string;
begin
  InputQuery('New message', 'Write something up ...', false, co);
  if co <> '' then
  begin
    TMessage.create(findChat(currentView.getParameter())[0], currentUser, co);
    currentView.switch('Chat', currentView.getParameter());
  end;
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

procedure TForm1.createGroupCreateButtonClick(Sender: TObject);
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
  if ( length(editChatGroupEdit.Text) > 0 ) and ( group = nil ) then
    showMessage('Group does not exist')
  else
  begin
    chat := findChat(currentView.getParameter())[0].update(group, editChatNameEdit.Text);
    TUserChat.create(currentUser, chat);
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

procedure TForm1.groupEditButtonClick(Sender: TObject);
begin
  currentView.switch('Edit group', currentView.getParameter());
end;

procedure TForm1.groupInviteMemberButtonClick(Sender: TObject);
begin
  currentView.switch('New group invitation', currentView.getParameter());
end;

procedure TForm1.homeCreateChatButtonClick(Sender: TObject);
begin
  currentView.switch('Create chat', 0);
end;

procedure TForm1.homeCreateGroupButtonClick(Sender: TObject);
begin
  currentView.switch('Create group', 0);
end;

procedure TForm1.newChatInvitationInviteButtonClick(Sender: TObject);
var user: TUser; i: integer; userIsMember: boolean;
begin
  userIsMember := false;
  if length(findUserByUsername(newChatInvitationUsernameEdit.text)) > 0 then
  begin
    user := findUserByUsername(newChatInvitationUsernameEdit.text)[0];
    for i:=0 to length(findUserChatByChat(findChat(currentView.getParameter())[0])) - 1 do
      if findUserChatByChat(findChat(currentView.getParameter())[0])[i].getUserId() = user.getId() then
        userIsMember := true;
    if userIsMember then
      showMessage('User is already a member')
    else
    begin
      TUserChat.create(user, findChat(currentView.getParameter())[0]);
      newChatInvitationUsernameEdit.text := '';
      currentView.switch('Chat', currentView.getParameter());
    end;
  end
  else
    showMessage('User does not exist');
end;

procedure TForm1.newGroupInvitationIviteButtonClick(Sender: TObject);
var user: TUser; i: integer; userIsMember: boolean;
begin
  userIsMember := false;
  if length(findUserByUsername(newGroupInvitationUsernameEdit.text)) > 0 then
  begin
    user := findUserByUsername(newGroupInvitationUsernameEdit.text)[0];
    for i:=0 to length(findUserGroupByGroup(findGroup(currentView.getParameter())[0])) - 1 do
      if findUserGroupByGroup(findGroup(currentView.getParameter())[0])[i].getUserId() = user.getId() then
        userIsMember := true;
    if userIsMember then
      showMessage('User is already a member')
    else
    begin
      TUserGroup.create(user, findGroup(currentView.getParameter())[0]);
      newGroupInvitationUsernameEdit.text := '';
      currentView.switch('Group', currentView.getParameter());
    end;
  end
  else
    showMessage('User does not exist');
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

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
  if (currentView <> nil) and (currentView.getCurrent() = c) then
    currentView.setParameter(p)
  else
    currentView := TView.create(c, currentView, p);
  if currentView.getReferrer() <> nil then
    Form1.backButton.Enabled := true
  else
    Form1.backButton.Enabled := false;
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
    'New chat invitation': result := 10;
    'New group invitation': result := 11;
  end;
end;

function TView.initialize(): boolean;
var
  userGroups: TUserGroupArray;
  userChats: TUserChatArray;
  groupChats: TChatArray;
  chatMessages: TMessageArray;
  groupUserGroups: TUserGroupArray;
  chatUserChats: TUserChatArray;
  group: TGroup;
  chat: TChat;
  i, j, toTop, panelToTop: integer;
  panel: TPanel;
  text: TLabel;
  button: TButton;
begin
  panelToTop := 225;
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
    userGroups := findUserGroupByUser(currentUser);
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
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := findGroup(userGroups[i].getGroupId())[0].getName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 37;
      text.caption := findGroup(userGroups[i].getGroupId())[0].getDescription();
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 60;
      button.caption := 'Open';
      button.helpKeyword := 'Group';
      button.helpContext := userGroups[i].getGroupId();
      button.OnClick := @openButtonClick;
    end;
    userChats := findUserChatByUser(currentUser);
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
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := findChat(userChats[i].getChatId())[0].getName();
      if ( findChat(userChats[i].getChatId())[0].getGroupId() <> 0) and ( length(findGroup(findChat(userChats[i].getChatId())[0].getGroupId())) > 0 ) then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 37;
        text.caption := findGroup(findChat(userChats[i].getChatId())[0].getGroupId())[0].getName();
      end;
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 60;
      button.caption := 'Open';
      button.helpKeyword := 'Chat';
      button.helpContext := userChats[i].getChatId();
      button.OnClick := @openButtonClick;
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
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := groupChats[i].getName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 45;
      text.caption := group.getName();
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 70;
      button.caption := 'Open';
      button.helpKeyword := 'Chat';
      button.helpContext := groupChats[i].getId();
      button.OnClick := @openButtonClick;
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
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(groupUserGroups[i].getUserId())[0].getFirstName() + ' ' + findUser(groupUserGroups[i].getUserId())[0].getLastName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 45;
      text.caption := '@' + findUser(groupUserGroups[i].getUserId())[0].getUsername();
      if findUser(groupUserGroups[i].getUserId())[0].getId() = group.getUserId() then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 70;
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
      panel.top := panelToTop;
      panel.width := 275;
      panel.caption := '';
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(chatMessages[i].getUserId())[0].getFirstName + ' ' + findUser(chatMessages[i].getUserId())[0].getLastName + ' (@' + findUser(chatMessages[i].getUserId())[0].getUsername + ')';
      j := 0;
      toTop := 45;
      repeat
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := toTop;
        text.caption := copy(chatMessages[i].getContent(), j, j + 40);
        inc(j, 40);
        inc(toTop, 25);
      until (j >= length(chatMessages[i].getContent()));
      panel.height := toTop + 15;
      inc(panelToTop, panel.height);
    end;
    if panelToTop + 75 < Form1.PageControl1.height then
      Form1.PageControl1.height := panelToTop + 75;
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
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := findUser(chatUserChats[i].getUserId())[0].getFirstName() + ' ' + findUser(chatUserChats[i].getUserId())[0].getLastName();
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 45;
      text.caption := '@' + findUser(chatUserChats[i].getUserId())[0].getUsername();
      if findUser(chatUserChats[i].getUserId())[0].getId() = chat.getUserId() then
      begin
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := 70;
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
  if self.getCurrent() = 'Edit group' then
  begin
    group := findGroup(currentView.getParameter())[0];
    Form1.editGroupNameEdit.Text := group.getName();
    Form1.editGroupDescriptionEdit.Text := group.getDescription();
  end;
  if self.getCurrent() = 'Edit chat' then
  begin
    chat := findChat(currentView.getParameter())[0];
    Form1.editChatNameEdit.Text := chat.getName();
    if length(findGroup(chat.getGroupId())) > 0 then
    Form1.editChatGroupEdit.Text := findGroup(chat.getGroupId())[0].getName();
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

procedure TView.openButtonClick(Sender: TObject);
begin
  with Sender as TButton do
  begin
    currentView.switch(helpKeyword, helpContext);
  end;
end;

initialization

randomize();

end.
