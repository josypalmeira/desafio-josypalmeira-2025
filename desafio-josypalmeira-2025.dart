index.js
class AbrigoAnimais {

 const animais = [
        { nome: "Rex", tipo: "cão", brinquedos: ["RATO", "BOLA"] },
        { nome: "Mimi", tipo: "gato", brinquedos: ["BOLA", "LASER"] },
        { nome: "Fofo", tipo: "gato", brinquedos: ["BOLA", "RATO", "LASER"] },
        { nome: "Zero", tipo: "gato", brinquedos: ["RATO", "BOLA"] },
        { nome: "Bola", tipo: "cão", brinquedos: ["CAIXA", "NOVELO"] },
        { nome: "Bebe", tipo: "cão", brinquedos: ["LASER", "RATO", "BOLA"] },
        { nome: "Loco", tipo: "jabuti", brinquedos: ["SKATE", "RATO"] }
    ];
    function validarBrinquedos(brinquedos) {
        const brinquedosSet = new Set(brinquedos);
        if (brinquedosSet.size !== brinquedos.length) {
            return "Brinquedo inválido";
        }
        return null; // Sem erro
    }
    function verificarCompatibilidade(brinquedosAnimal, brinquedosPessoa) {
        // Verifica se a pessoa tem todos os brinquedos do animal na ordem
        let indicePessoa = 0;
        for (const brinquedoAnimal of brinquedosAnimal) {
            let encontrado = false;
            while (indicePessoa < brinquedosPessoa.length) {
                if (brinquedosPessoa[indicePessoa] === brinquedoAnimal) {
                    encontrado = true;
                    indicePessoa++;
                    break;
                }
                indicePessoa++;
            }
            if (!encontrado) {
                return false;
            }
        }
        return true;
    }

    function verificarCompatibilidadeLoco(brinquedosAnimal, brinquedosPessoa, outrosAnimaisAdotados) {
        // Loco não se importa com a ordem, desde que tenha outro animal como companhia
        if (outrosAnimaisAdotados.length === 0) {
            return false; // Precisa de companhia
        }
        const brinquedosPessoaSet = new Set(brinquedosPessoa);
        for (const brinquedoAnimal of brinquedosAnimal) {
            if (!brinquedosPessoaSet.has(brinquedoAnimal)) {
                return false;
            }
        }
        return true;
    }
    function organizarAbrigo(brinquedosPessoa1, brinquedosPessoa2, ordemAnimais) {
        const brinquedosP1 = brinquedosPessoa1.split(',');
        const brinquedosP2 = brinquedosPessoa2.split(',');
        const ordem = ordemAnimais.split(',');

        const erroBrinquedoP1 = validarBrinquedos(brinquedosP1);
        const erroBrinquedoP2 = validarBrinquedos(brinquedosP2);

        if (erroBrinquedoP1) return erroBrinquedoP1;
        if (erroBrinquedoP2) return erroBrinquedoP2;

        const resultadoAdocao = {};
        const animaisAdotadosPorPessoa = { pessoa1: 0, pessoa2: 0 };
        const gatosAdotados = new Set();
        const animaisJaConsiderados = new Set();

        for (const nomeAnimal of ordem) {
            const animal = animais.find(a => a.nome === nomeAnimal);

            if (!animal) {
                return "Animal inválido";
            }
            if (animaisJaConsiderados.has(nomeAnimal)) {
                return "Animal inválido"; // Duplicado na ordem
            }
            animaisJaConsiderados.add(nomeAnimal);

            const aptoPessoa1 = (animal.tipo === "jabuti")
                ? verificarCompatibilidadeLoco(animal.brinquedos, brinquedosP1, Array.from(gatosAdotados.keys()).filter(g => resultadoAdocao[g] === "pessoa1"))
                : verificarCompatibilidade(animal.brinquedos, brinquedosP1);

            const aptoPessoa2 = (animal.tipo === "jabuti")
                ? verificarCompatibilidadeLoco(animal.brinquedos, brinquedosP2, Array.from(gatosAdotados.keys()).filter(g => resultadoAdocao[g] === "pessoa2"))
                : verificarCompatibilidade(animal.brinquedos, brinquedosP2);

            let adotadoPor = "abrigo";

            if (aptoPessoa1 && aptoPessoa2) {
                adotadoPor = "abrigo"; // Se ambos são aptos, volta pro abrigo
            } else if (aptoPessoa1 && animaisAdotadosPorPessoa.pessoa1 < 3) {
                if (animal.tipo === "gato") {
                    if (gatosAdotados.has(animal.nome)) {
                        adotadoPor = "abrigo";
                    } else {
                        gatosAdotados.add(animal.nome);
                        animaisAdotadosPorPessoa.pessoa1++;
                        adotadoPor = "pessoa1";
                    }
                } else {
                    animaisAdotadosPorPessoa.pessoa1++;
                    adotadoPor = "pessoa1";
                }
            } else if (aptoPessoa2 && animaisAdotadosPorPessoa.pessoa2 < 3) {
                if (animal.tipo === "gato") {
                    if (gatosAdotados.has(animal.nome)) {
                        adotadoPor = "abrigo";
                    } else {
                        gatosAdotados.add(animal.nome);
                        animaisAdotadosPorPessoa.pessoa2++;
                        adotadoPor = "pessoa2";
                    }
                } else {
                    animaisAdotadosPorPessoa.pessoa2++;
                    adotadoPor = "pessoa2";
                }
            }

            resultadoAdocao[animal.nome] = adotadoPor;
        }

        // Ordena os animais alfabeticamente
        const animaisOrdenados = Object.keys(resultadoAdocao).sort();
        const saida = animaisOrdenados.map(nome => {
            const pessoa = resultadoAdocao[nome];
            return `${nome} - ${pessoa === "pessoa1" ? "pessoa 1" : pessoa === "pessoa2" ? "pessoa 2" : "abrigo"}`;
        });

        return saida;
    }
    export { AbrigoAnimais as AbrigoAnimais};

