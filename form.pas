unit Form;

{$mode objfpc}{$H+}

interface

uses
  User, Group, UserGroup, Chat, UserChat, Message, Classes, SysUtils, sqldb,
  mysql56conn, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls;

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
    homeButton: TButton;
    chatEditButton: TButton;
    groupEditButton: TButton;
    MySQL56Connection1: TMySQL56Connection;
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
    SQLTransaction1: TSQLTransaction;
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
    procedure homeButtonClick(Sender: TObject);
    procedure homeCreateChatButtonClick(Sender: TObject);
    procedure homeCreateGroupButtonClick(Sender: TObject);
    procedure newChatInvitationInviteButtonClick(Sender: TObject);
    procedure newGroupInvitationIviteButtonClick(Sender: TObject);
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

  { TCard }

  TCard = class
  private
    title: string;
    content: string;
    buttonId: integer;
    buttonView: string;
  protected
    function setTitle(t: string): string;
    function setContent(c: string): string;
    function setButtonId(bi: integer): integer;
    function setButtonView(bv: string): string;
  public
    constructor create(t, c: string; bi: integer; bv: string);
    function getTitle(): string;
    function getContent(): string;
    function getButtonId(): integer;
    function getButtonView(): string;
  end;

  TCardArray = array of TCard;

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
    function getTabIndex(): integer;
    function getTabSheet(): TTabSheet;
    function initialize(): boolean;
    function cleanup(): boolean;
    function renderCards(column: integer; content: TCardArray): boolean;
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
    homeButton.Visible := false;
    accountButton.Visible := false;
    signoutButton.Visible := false;
  end
  else
  begin
    userLabel.Caption := 'Logged in as:';
    usernameLabel.Caption := '@' + currentUser.getUsername();
    loginButton.Visible := false;
    signupButton.Visible := false;
    homeButton.Visible := true;
    accountButton.Visible := true;
    signoutButton.Visible := true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TChat.seed();
  TGroup.seed();
  TMessage.seed();
  TUser.seed();
  TUserChat.seed();
  TUserGroup.seed();
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
    TMessage.create(TChat.find(currentView.getParameter()), currentUser, co);
    currentView.switch('Chat', currentView.getParameter());
  end;
end;

procedure TForm1.createChatCreateButtonClick(Sender: TObject);
var chat: TChat; group: TGroup;
begin
  if length(TGroup.whereName(createChatGroupEdit.Text)) > 0 then
    if TGroup.whereName(createChatGroupEdit.Text)[0].getUserId = currentUser.getId() then
      group := TGroup.whereName(createChatGroupEdit.Text)[0]
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
  if length(TGroup.whereName(editChatGroupEdit.Text)) > 0 then
    if TGroup.whereName(editChatGroupEdit.Text)[0].getUserId = currentUser.getId() then
      group := TGroup.whereName(editChatGroupEdit.Text)[0]
    else
      showMessage('You do not own this group')
  else
    group := nil;
  if ( length(editChatGroupEdit.Text) > 0 ) and ( group = nil ) then
    showMessage('Group does not exist')
  else
  begin
    chat := TChat.find(currentView.getParameter()).update(group, editChatNameEdit.Text);
    editChatNameEdit.Text := '';
    editChatGroupEdit.Text := '';
    currentView.switch('Chat', chat.getId());
  end;
end;

procedure TForm1.editGroupUpdateButtonClick(Sender: TObject);
var group: TGroup;
begin
  group := TGroup.find(currentView.getParameter()).update(editGroupNameEdit.Text, editGroupDescriptionEdit.Text);
  editGroupNameEdit.Text := '';
  editGroupDescriptionEdit.Text := '';
  currentView.switch('Group', group.getId());
end;

procedure TForm1.groupCreateChatButtonClick(Sender: TObject);
begin
  currentView.switch('Create chat', TGroup.whereName(groupNameLabel.caption)[0].getId());
end;

procedure TForm1.groupEditButtonClick(Sender: TObject);
begin
  currentView.switch('Edit group', currentView.getParameter());
end;

procedure TForm1.groupInviteMemberButtonClick(Sender: TObject);
begin
  currentView.switch('New group invitation', currentView.getParameter());
end;

procedure TForm1.homeButtonClick(Sender: TObject);
begin
  currentView.switch('Home', 0);
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
  if length(TUser.whereUsername(newChatInvitationUsernameEdit.text)) > 0 then
  begin
    user := TUser.whereUsername(newChatInvitationUsernameEdit.text)[0];
    for i:=0 to length(TUserChat.whereChat(TChat.find(currentView.getParameter()))) - 1 do
      if TUserChat.whereChat(TChat.find(currentView.getParameter()))[i].getUserId() = user.getId() then
        userIsMember := true;
    if userIsMember then
      showMessage('User is already a member')
    else
    begin
      TUserChat.create(user, TChat.find(currentView.getParameter()));
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
  if length(TUser.whereUsername(newGroupInvitationUsernameEdit.text)) > 0 then
  begin
    user := TUser.whereUsername(newGroupInvitationUsernameEdit.text)[0];
    for i:=0 to length(TUserGroup.whereGroup(TGroup.find(currentView.getParameter()))) - 1 do
      if TUserGroup.whereGroup(TGroup.find(currentView.getParameter()))[i].getUserId() = user.getId() then
        userIsMember := true;
    if userIsMember then
      showMessage('User is already a member')
    else
    begin
      TUserGroup.create(user, TGroup.find(currentView.getParameter()));
      newGroupInvitationUsernameEdit.text := '';
      currentView.switch('Group', currentView.getParameter());
    end;
  end
  else
    showMessage('User does not exist');
end;

{ TCard }

constructor TCard.create(t, c: string; bi: integer; bv: string);
begin
  inherited create();
  self.setTitle(t);
  self.setContent(c);
  self.setButtonId(bi);
  self.setButtonView(bv);
end;

function TCard.getTitle(): string;
begin
  result := self.title;
end;

function TCard.getContent(): string;
begin
  result := self.content;
end;

function TCard.getButtonId(): integer;
begin
  result := self.buttonId;
end;

function TCard.getButtonView(): string;
begin
  result := self.buttonView;
end;

function TCard.setTitle(t: string): string;
begin
  self.title := t;
  result := self.getTitle();
end;

function TCard.setContent(c: string): string;
begin
  self.content := c;
  result := self.getContent();
end;

function TCard.setButtonId(bi: integer): integer;
begin
  self.buttonId := bi;
  result := self.getButtonId();
end;

function TCard.setButtonView(bv: string): string;
begin
  self.buttonView := bv;
  result := self.getButtonView();
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

function TView.getTabIndex(): integer;
begin
  case self.getCurrent() of
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

function TView.getTabSheet(): TTabSheet;
begin
  case self.getCurrent() of
    'Home': result := Form1.TabSheet1;
    'Account': result := Form1.TabSheet2;
    'Login': result := Form1.TabSheet3;
    'Signup': result := Form1.TabSheet4;
    'Group': result := Form1.TabSheet5;
    'Chat': result := Form1.TabSheet6;
    'Create chat': result := Form1.TabSheet7;
    'Create group': result := Form1.TabSheet8;
    'Edit chat': result := Form1.TabSheet9;
    'Edit group': result := Form1.TabSheet10;
    'New chat invitation': result := Form1.TabSheet11;
    'New group invitation': result := Form1.TabSheet12;
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
  cardArray: TCardArray;
  i: integer;
begin
  self.cleanup();
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
    userGroups := TUserGroup.whereUser(currentUser);
    setLength(cardArray, length(userGroups));
    for i:=0 to length(userGroups) - 1 do
    begin
      cardArray[i] := TCard.create(
        TGroup.find(userGroups[i].getGroupId()).getName(),
        TGroup.find(userGroups[i].getGroupId()).getDescription(),
        userGroups[i].getGroupId(),
        'Group'
      );
    end;
    self.renderCards(1, cardArray);
    userChats := TUserChat.whereUser(currentUser);
    setLength(cardArray, length(userChats));
    for i:=0 to length(userChats) - 1 do
    begin
      cardArray[i] := TCard.create(
        TChat.find(userChats[i].getChatId()).getName(),
        '-',
        userChats[i].getChatId(),
        'Chat'
      );
      if ( TChat.find(userChats[i].getChatId()).getGroupId() <> 0 ) and ( TGroup.find(TChat.find(userChats[i].getChatId()).getGroupId()) <> nil ) then
        cardArray[i].setContent(TGroup.find(TChat.find(userChats[i].getChatId()).getGroupId()).getName());
    end;
    self.renderCards(2, cardArray);
  end;
  if self.getCurrent() = 'Group' then
  begin
    group := TGroup.find(self.getParameter());
    Form1.groupNameLabel.caption := group.getName();
    Form1.groupDescriptionLabel.caption := group.getDescription();
    if currentUser.getId() = group.getUserId() then
      Form1.groupEditButton.visible := true
    else
      Form1.groupEditButton.visible := false;
    groupChats := TChat.whereGroup(group);
    setLength(cardArray, length(groupChats));
    for i:=0 to length(groupChats) - 1 do
    begin
      cardArray[i] := TCard.create(
        groupChats[i].getName(),
        group.getName(),
        groupChats[i].getId(),
        'Chat'
      );
    end;
    self.renderCards(1, cardArray);
    groupUserGroups := TUserGroup.whereGroup(group);
    setLength(cardArray, length(groupUserGroups));
    for i:=0 to length(groupUserGroups) - 1 do
    begin
      cardArray[i] := TCard.create(
        TUser.find(groupUserGroups[i].getUserId()).getFirstName() + ' ' + TUser.find(groupUserGroups[i].getUserId()).getLastName(),
        '@' + TUser.find(groupUserGroups[i].getUserId()).getUsername(), 0, ''
      );
      if TUser.find(groupUserGroups[i].getUserId()).getId() = group.getUserId() then
        cardArray[i].setContent(cardArray[i].getContent() + ' - Admin')
    end;
    self.renderCards(2, cardArray);
  end;
  if self.getCurrent() = 'Chat' then
  begin
    chat := TChat.find(self.getParameter());
    Form1.chatNameLabel.caption := chat.getName();
    if currentUser.getId() = chat.getUserId() then
      Form1.chatEditButton.visible := true
    else
      Form1.chatEditButton.visible := false;
    chatMessages := TMessage.whereChat(chat);
    setLength(cardArray, length(chatMessages));
    for i:=0 to length(chatMessages) - 1 do
    begin
      cardArray[i] := TCard.create(
        TUser.find(chatMessages[i].getUserId()).getFirstName + ' ' + TUser.find(chatMessages[i].getUserId()).getLastName + ' (@' + TUser.find(chatMessages[i].getUserId()).getUsername + ')',
        chatMessages[i].getContent(), 0, ''
      );
    end;
    self.renderCards(1, cardArray);
    chatUserChats := TUserChat.whereChat(chat);
    setLength(cardArray, length(chatUserChats));
    for i:=0 to length(chatUserChats) - 1 do
    begin
      cardArray[i] := TCard.create(
        TUser.find(chatUserChats[i].getUserId()).getFirstName() + ' ' + TUser.find(chatUserChats[i].getUserId()).getLastName(),
        '@' + TUser.find(chatUserChats[i].getUserId()).getUsername(), 0, ''
      );
      if TUser.find(chatUserChats[i].getUserId()).getId() = chat.getUserId() then
        cardArray[i].setContent(cardArray[i].getContent() + ' - Admin');
    end;
    self.renderCards(2, cardArray);
  end;
  if self.getCurrent() = 'Create chat' then
  begin
    if self.getParameter() <> 0 then
    begin
      group := TGroup.find(self.getParameter);
      Form1.createChatGroupEdit.text := group.getName();
    end;
  end;
  if self.getCurrent() = 'Edit group' then
  begin
    group := TGroup.find(currentView.getParameter());
    Form1.editGroupNameEdit.Text := group.getName();
    Form1.editGroupDescriptionEdit.Text := group.getDescription();
  end;
  if self.getCurrent() = 'Edit chat' then
  begin
    chat := TChat.find(currentView.getParameter());
    Form1.editChatNameEdit.Text := chat.getName();
    if TGroup.find(chat.getGroupId()) <> nil then
      Form1.editChatGroupEdit.Text := TGroup.find(chat.getGroupId()).getName();
  end;
  if self.getCurrent() = 'Account' then
  begin
    Form1.accountFirstNameEdit.Text := currentUser.getFirstName();
    Form1.accountLastNameEdit.Text := currentUser.getLastName();
    Form1.accountUsernameEdit.Text := currentUser.getUsername();
  end;
  Form1.PageControl1.TabIndex := self.getTabIndex();
  result := true;
end;

function TView.cleanup(): boolean;
var i: integer;
begin
  for i := (self.getTabSheet().controlCount - 1) downto 0 do
    if self.getTabSheet().controls[i].helpKeyword = 'temp' then
      self.getTabSheet().controls[i].free();
  result := true;
end;

function TView.renderCards(column: integer; content: TCardArray): boolean;
var
  i, j, toTop, panelToTop: integer;
  panel: TPanel;
  text: TLabel;
  button: TButton;
begin
  panelToTop := 225;
  for i:=0 to length(content) - 1 do
  begin
    panel := TPanel.create(Form1);
    panel.parent := self.getTabSheet();
    if column = 1 then
      panel.left := 40
    else
      panel.left := 350;
    panel.top := panelToTop;
    panel.width := 275;
    panel.caption := '';
    panel.helpKeyword := 'temp';
    if content[i].getTitle() <> '' then
    begin
      text := TLabel.create(Form1);
      text.parent := panel;
      text.left := 15;
      text.top := 15;
      text.font.size := 14;
      text.font.style := text.font.style + [fsBold];
      text.caption := content[i].getTitle();
    end;
    if content[i].getContent() <> '' then
    begin
      j := 0;
      toTop := 45;
      repeat
        text := TLabel.create(Form1);
        text.parent := panel;
        text.left := 15;
        text.top := toTop;
        text.caption := copy(content[i].getContent(), j, j + 40);
        inc(j, 40);
        inc(toTop, 25);
      until j >= length(content[i].getContent());
    end;
    if (content[i].getButtonId() <> 0) and (content[i].getButtonView() <> '') then
    begin
      button := TButton.create(Form1);
      button.parent := panel;
      button.left := 15;
      button.top := 70;
      button.caption := 'Open';
      button.helpKeyword := content[i].getButtonView();
      button.helpContext := content[i].getButtonId();
      button.OnClick := @openButtonClick;
      panel.height := toTop + 45
    end
    else
      panel.height := toTop + 15;
    inc(panelToTop, panel.height);
  end;
  if panelToTop + 75 > Form1.PageControl1.height then
    Form1.PageControl1.height := panelToTop + 75;
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
