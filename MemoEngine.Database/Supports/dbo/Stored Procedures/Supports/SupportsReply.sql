-- 게시판 아티클에 답변 저장 
CREATE PROCEDURE [dbo].[SupportsReply]
    @Name       NVarChar(25), 
    @PostIp     NVarChar(15), 
    @Title      NVarChar(150), 
    @Content    NVarChar(Max), 
    @Category   NVarChar(10) = '', 

    @Email      NVarChar(100), 
    @Password   NVarChar(255), 
    @Encoding   NVarChar(10), 
    @Homepage   NVarChar(100),
    @ParentNum  Int,                    -- 부모글의 고유번호(Id)
    @FileName   NVarChar(255),
    @FileSize   Int,
    @UserName NVarChar(100) -- 사용자 아이디
AS
    --[0] 변수 선언
    Declare @MaxRefOrder Int
    Declare @MaxRefAnswerNum Int
    Declare @ParentRef Int
    Declare @ParentStep Int
    Declare @ParentRefOrder Int

    --[1] 부모글의 답변수(AnswerNum)를 1증가
    Update Supports Set AnswerNum = AnswerNum + 1 Where Id = @ParentNum 

    --[2] 같은 글에 대해서 답변을 두 번 이상하면 먼저 답변한 게 위에 나타나게 한다.
    Select @MaxRefOrder = RefOrder, @MaxRefAnswerNum = AnswerNum From Supports 
    Where 
        ParentNum = @ParentNum And 
        RefOrder = (Select Max(RefOrder) From Supports Where ParentNum = @ParentNum)

    If @MaxRefOrder Is Null
    Begin
        Select @MaxRefOrder = RefOrder From Supports Where Id = @ParentNum
        Set @MaxRefAnswerNum = 0  
    End 

    --[3] 중간에 답변달 때(비집고 들어갈 자리 마련)
    Select @ParentRef = Ref, @ParentStep = Step  From Supports Where Id = @ParentNum

    Update Supports Set RefOrder = RefOrder + 1  
	Where Ref = @ParentRef And RefOrder > (@MaxRefOrder + @MaxRefAnswerNum)

    --[4] 최종저장
    Insert Supports
    (
        Name, Email, Title, PostIp, Content, Password, Encoding, 
        Homepage, Ref, Step, RefOrder, ParentNum, FileName, FileSize,
        Category, UserName  
    )
    Values
    (
        @Name, @Email, @Title, @PostIp, @Content, @Password, @Encoding, 
        @Homepage, @ParentRef, @ParentStep + 1, 
        @MaxRefOrder + @MaxRefAnswerNum + 1, @ParentNum, @FileName, @FileSize,
        @Category, @UserName
    )
Go
