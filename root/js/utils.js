/*****************************************
 * formButtons
 *****************************************
 * Cria os botões que faltam no
 * formulário.
 *
 * @param form: Nome do formulário.
 *****************************************/

function formButtons (nomeForm) {
    var divFormActions  = document.getElementsByClassName("form-actions")[0];
    var botaoLimpar     = document.createElement ("input");
    var botaoVoltar     = document.createElement ("input");
    
    /* --------------------------------
     * Botão limpar
     * --------------------------------
     */

    botaoLimpar.id      = "bLimpar";
    botaoLimpar.name    = "bLimpar";
    botaoLimpar.type    = "button";
    botaoLimpar.value   = "Limpar";
    botaoLimpar.setAttribute ("class", "btn btn-primary");
    botaoLimpar.setAttribute ("onclick", "document.getElementById ('" + nomeForm + "').reset ()");

    /* -------------------------------- */



    /* --------------------------------
     * Botão voltar
     * --------------------------------
     */

    botaoVoltar.id      = "bVoltar";
    botaoVoltar.name    = "bVoltar";
    botaoVoltar.type    = "button";
    botaoVoltar.value   = "Voltar";
    botaoVoltar.setAttribute ("class", "btn btn-danger");

    /* --------------------------------- */



    /* --------------------------------- 
     * Anexa os botões na div dos
     * botões de formulário.
     * ---------------------------------
     */

    divFormActions.appendChild (botaoLimpar);
    divFormActions.appendChild (document.createTextNode (" "));
    divFormActions.appendChild (botaoVoltar);
    
    /* --------------------------------- */
}

/******************************************/

