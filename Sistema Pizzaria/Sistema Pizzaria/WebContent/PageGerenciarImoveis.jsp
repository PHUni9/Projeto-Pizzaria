<%@ include file="Protecao.jsp" %>

<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body>
	
<style type="text/css">
    table,tr,th{
        border: 1px solid black;
        border-spacing: 0px;
    }
    tr,td,th{
    	border: 1px solid black;
        padding: 8px;
        padding-left: 8px;
        padding-right:15px;
    }
</style>
<br />
<a href="PageAreaAdministrativa.jsp">Voltar</a>
<br /><br />
<h2>Gerenciar imóveis</h2>
<br>

<form>

	Foto do produto<br />
	<img id="foto" style="height:150px; width:150px; border:1px solid black"><br />
	<input id="inp" type="file">

	<br /><br />
	<!-- Foto...........: <span id="foto_texto"></span><br> -->
	Código.........: <input type="text" id="codigo" disabled><br>
	Tipo imóvel: <input type="text" id="tipo"><br>
	Valor..............: <input type="text" id="valor"><br><br>
	
	<input type="button" value="Buscar" onclick="consultar()">
	<input type="button" value="Salvar" onclick="inserirOuAlterar()">
	<input type="reset" value="Limpar" onclick="limpar()"><br><br>
</form>

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

	function editar(codigo, foto, tipo, valor){
		document.getElementById("codigo").value = codigo;
		document.getElementById("foto").src = foto;
		document.getElementById("tipo").value = tipo;
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
		jsonEnvio.tipo   = document.getElementById("tipo").value;
		jsonEnvio.valor  = document.getElementById("valor").value;
		
		if (jsonEnvio.codigo!=""){
			jsonEnvio.acao = "alterar";	
		}else{
			jsonEnvio.acao = "inserir";
		}
		$.ajax({
			url: "ImovelServlet",
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
			url: "ImovelServlet",
			data: jsonEnvio,
			type:"post",
			success: function (resp){
				var jsonVetor = JSON.parse(resp);
				var linhas = "";
				
				for (i=0;i<jsonVetor.length;i++){
					
					var codigo = jsonVetor[i].codigo;
					var foto   = jsonVetor[i].foto;
					var tipo   = jsonVetor[i].tipo;
					var valor  = jsonVetor[i].valor;
					
					linhas += `
						<tr>
							<td><img src="imagens/edit.png" onclick="editar(`+ codigo + `, '`+ foto + `', '`+ tipo + `', `+ valor + `)"/></td>
							<td><img src="imagens/delete.png" onclick="confirmarExcluir(`+ codigo + `)"/></td>
							<td>`+ codigo + `</td>
							<td>`+ tipo + `</td>
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
			url: "ImovelServlet",
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

<table>
    <thead>
        <tr>
            <th>Editar</th>
            <th>Excluir</th>
            <th>Código</th>
            <th>Tipo</th>
            <th>Valor (R$)</th>
        </tr>
    </thead>
    <tbody id="corpo_da_tabela">
    </tbody>
</table>
	
</body>
</html>