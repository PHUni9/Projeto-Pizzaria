<%@ include file="Protecao.jsp" %>

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
        <h2>Gerenciar Pizzas</h2>
        <br />
        <form>
            Foto do Produto<br />
            <img id="foto" style="height:150px; width:150px; border:1px solid black"><br />
            <input id="inp" type="file">

            <br /><br />
            Código.........: <input type="text" id="codigo" disabled><br>
            Sabor..........: <input type="text" id="sabor"><br>
            Valor..........: <input type="text" id="valor"><br><br>

            <input type="button" value="Buscar" onclick="consultar()">
            <input type="button" value="Salvar" onclick="inserirOuAlterar()">
            <input type="reset" value="Limpar" onclick="limpar()"><br><br>
        </form>

        <table>
            <thead>
                <tr>
                    <th>Editar</th>
                    <th>Excluir</th>
                    <th>Código</th>
                    <th>Sabor</th>
                    <th>Valor (R$)</th>
                </tr>
            </thead>
            <tbody id="corpo_da_tabela">
            </tbody>
        </table>
    </div>

    <script>
        function limpar(){
            document.getElementById("foto").src = null;
        }

        function readFile() {  
            if (!this.files || !this.files[0]) return;    
            const fileReader = new FileReader();    
            fileReader.addEventListener("load", function(evt) {
                document.querySelector("#foto").src = evt.target.result;
            }); 
            fileReader.readAsDataURL(this.files[0]);  
        }
        document.querySelector("#inp").addEventListener("change", readFile);

        function editar(codigo, foto, sabor, valor){
            document.getElementById("codigo").value = codigo;
            document.getElementById("foto").src = foto;
            document.getElementById("sabor").value = sabor;
            document.getElementById("valor").value = valor;
        }

        function confirmarExcluir(codigo){
            if (confirm("Deseja realmente excluir?")){
                excluir(codigo);
            }
        }

        function inserirOuAlterar(){        
            var jsonEnvio = {};
            jsonEnvio.codigo = document.getElementById("codigo").value;
            jsonEnvio.foto   = document.getElementById("foto").src;
            jsonEnvio.sabor  = document.getElementById("sabor").value;
            jsonEnvio.valor  = document.getElementById("valor").value;

            if (jsonEnvio.codigo!=""){
                jsonEnvio.acao = "alterar";    
            } else {
                jsonEnvio.acao = "inserir";
            }
            $.ajax({
                url: "PizzaServlet",
                data: jsonEnvio,
                type:"post",
                success: function (resp){
                    alert(resp);
                    consultar();
                },
                error: function (){
                    alert("Ocorreu um erro ao excluir!!!");
                }
            });
        }

        function consultar(){
            var jsonEnvio = {};
            jsonEnvio.acao = "consultar";
            $.ajax({
                url: "PizzaServlet",
                data: jsonEnvio,
                type:"post",
                success: function (resp){
                    var jsonVetor = JSON.parse(resp);
                    var linhas = "";

                    for (i=0; i<jsonVetor.length; i++){
                        var codigo = jsonVetor[i].codigo;
                        var foto   = jsonVetor[i].foto;
                        var sabor  = jsonVetor[i].sabor;
                        var valor  = jsonVetor[i].valor;

                        linhas += `
                            <tr>
                                <td><img src="imagens/edit.png" onclick="editar(`+ codigo + `, '`+ foto + `', '`+ sabor + `', `+ valor + `)"/></td>
                                <td><img src="imagens/delete.png" onclick="confirmarExcluir(`+ codigo + `)"/></td>
                                <td>`+ codigo + `</td>
                                <td>`+ sabor + `</td>
                                <td>`+ valor + `</td>
                            </tr>
                        `;
                    }

                    document.getElementById("corpo_da_tabela").innerHTML = linhas;
                },
                error: function (){
                    alert("Ocorreu um erro ao consultar!!!");
                }
            });
        }

        function excluir(codigo){
            var jsonEnvio = {};
            jsonEnvio.acao = "excluir";
            jsonEnvio.codigo = codigo;
            $.ajax({
                url: "PizzaServlet",
                data: jsonEnvio,
                type:"post",
                success: function (resp){
                    alert(resp);
                    consultar();
                },
                error: function (){
                    alert("Ocorreu um erro ao excluir!!!");
                }
            });
        }
    </script>
</body>
</html>
