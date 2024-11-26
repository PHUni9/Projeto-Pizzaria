<html lang="pt-br">
<head>
    <meta charset="utf-8"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <style>
        body {
            background-color: #333;
            color: white;
            font-family: "Inter", sans-serif;
            padding: 30px;
            margin: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .container {
            background-color: rgba(0, 0, 0, 0.8);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            width: 80%;
            max-width: 900px;
            text-align: center;
        }

        h2 {
            color: white;
            font-size: 28px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #444;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #444;
            color: white;
        }

        td {
            background-color: #555;
        }

        td img {
            width: 30px;
            height: 30px;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }

        td img:hover {
            transform: scale(1.2);
            opacity: 0.8;
        }

        input[type="text"] {
            padding: 8px;
            margin-bottom: 10px;
            width: 300px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        input[type="button"], input[type="reset"] {
            background-color: #ed1c0d;
            border: none;
            color: white;
            padding: 12px 25px;
            margin-top: 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="button"]:hover, input[type="reset"]:hover {
            background-color: #f99b1c;
            transition: background-color 0.3s;
        }

        a {
            color: #007bff; /* Azul */
            text-decoration: none;
            font-size: 18px;
        }

        a:hover {
            text-decoration: underline;
            color: #0056b3; /* Azul mais escuro ao passar o mouse */
        }

    </style>
</head>

<body>
    <div class="container">
        <a href="PageAreaAdministrativa.jsp">Voltar</a>
        <br /><br />
        <h2>Gerenciar Funcionários</h2>
        <br />
        <form>
            Matrícula: <input type="text" id="matricula" disabled /><br />
            Email......: <input type="text" id="email" /><br />
            Nome......: <input type="text" id="nome" /><br />
            Senha......: <input type="text" id="senha" /><br /><br />

            <input type="button" value="Buscar" onclick="consultar()" />
            <input type="button" value="Salvar" onclick="inserirOuAlterar()" />
            <input type="reset" value="Limpar" /><br /><br />
        </form>

        <table>
            <thead>
                <tr>
                    <th>Editar</th>
                    <th>Excluir</th>
                    <th>Matricula</th>
                    <th>E-mail</th>
                    <th>Nome</th>
                </tr>
            </thead>
            <tbody id="corpo_da_tabela">
                <!-- Os dados serão preenchidos via AJAX -->
            </tbody>
        </table>
    </div>

    <script>
        // Função para preencher o formulário com dados de um funcionário ao clicar no ícone de editar
        function editar(matricula, email, nome){
            document.getElementById("matricula").value = matricula;
            document.getElementById("email").value = email;
            document.getElementById("nome").value = nome;
        }

        // Função para confirmar a exclusão
        function confirmarExcluir(matricula){
            if (confirm("Deseja realmente excluir?")){
                excluir(matricula);
            }
        }

        // Função para inserir ou alterar um funcionário
        function inserirOuAlterar(){
            var jsonEnvio = {};
            jsonEnvio.matricula = document.getElementById("matricula").value;
            jsonEnvio.email = document.getElementById("email").value;
            jsonEnvio.nome = document.getElementById("nome").value;
            jsonEnvio.senha = document.getElementById("senha").value;
            jsonEnvio.acao = jsonEnvio.matricula ? "alterar" : "inserir";  // Condicional simplificada
            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    if (resp == "ok"){
                        alert("Funcionário cadastrado com sucesso!");
                        consultar();
                    } else {
                        alert(resp);
                    }
                },
                error: function (){
                    alert("Ocorreu um erro ao salvar!");
                }
            });
        }

        // Função para consultar os funcionários
        function consultar(){
            var jsonEnvio = { acao: "consultar" };
            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    document.getElementById("corpo_da_tabela").innerHTML = resp;
                },
                error: function (){
                    alert("Ocorreu um erro ao consultar!");
                }
            });
        }

        // Função para excluir um funcionário
        function excluir(matricula){
            var jsonEnvio = { acao: "excluir", matricula: matricula };
            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    alert(resp);
                    consultar();
                },
                error: function (){
                    alert("Ocorreu um erro ao excluir!");
                }
            });
        }

        // Função para gerar as imagens de editar e excluir na tabela
        function gerarLinhasTabela(dados) {
            var corpoTabela = document.getElementById("corpo_da_tabela");
            corpoTabela.innerHTML = ""; // Limpar conteúdo anterior
            dados.forEach(function(funcionario) {
                var linha = document.createElement("tr");

                // Criando a célula de editar com imagem
                linha.appendChild(criarCelulaImagem("src/imagens/edit.png", "Editar", function() {
                    editar(funcionario.matricula, funcionario.email, funcionario.nome);
                }));

                // Criando a célula de excluir com imagem
                linha.appendChild(criarCelulaImagem("src/imagens/delete.png", "Excluir", function() {
                    confirmarExcluir(funcionario.matricula);
                }));

                // Adicionando dados do funcionário
                linha.appendChild(criarCelula(funcionario.matricula));
                linha.appendChild(criarCelula(funcionario.email));
                linha.appendChild(criarCelula(funcionario.nome));

                corpoTabela.appendChild(linha);
            });
        }

        // Função para criar uma célula com imagem
        function criarCelulaImagem(src, alt, onClick) {
            var celula = document.createElement("td");
            var img = document.createElement("img");
            img.src = src;
            img.alt = alt;
            img.onclick = onClick;
            celula.appendChild(img);
            return celula;
        }

        // Função para criar uma célula com texto
        function criarCelula(texto) {
            var celula = document.createElement("td");
            celula.textContent = texto;
            return celula;
        }
    </script>
</body>
</html>
