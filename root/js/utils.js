/*****************************************
 * buscaCep 
 *****************************************
 * Requisição AJAX para preencher o endereço
 * baseado no CEP.
 *
 * @param cep: CEP do endereço.
 *****************************************/

function buscaCep (cep) {
    var jqxhr;
    var msg      = document.createTextNode ("Aguarde...");
    var campoCep = document.getElementById('formCliente').childNodes[7];
    var msgDone;

    campoCep.appendChild (msg);
    jqxhr   = $.ajax ({
      url: "busca_cep/" + cep,
      dataType: "json",
     }, 30000)  
     .done (function (dadosCep) {
          msgDone                                   = document.createTextNode (dadosCep.status);
          document.getElementById('endereco').value = dadosCep.street;
          document.getElementById('bairro').value   = dadosCep.neighborhood;
          document.getElementById('cidade').value   = dadosCep.location;
          campoCep.replaceChild (msgDone, msg);
     });
}

/******************************************/


function punctData (campoData) {
    if (campoData.value.length == 2 || campoData.value.length == 5) {
        campoData.value += "/";
    }
}
