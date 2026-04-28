class Toque {
  final int id;
  final String nome;
  final String audio;
  final String bizu;

  const Toque({
    required this.id,
    required this.nome,
    required this.audio,
    this.bizu = '',
  });
}

const List<Toque> toques = [
  Toque(id: 1,  nome: 'Sentido',           audio: 'sentido.aac',           bizu: 'Aluno só fica em sentido'),
  Toque(id: 2,  nome: 'Descansar',         audio: 'descansar.aac',         bizu: 'Des-can-sar'),
  Toque(id: 3,  nome: 'Apresentar Arma',   audio: 'apresentar-arma.aac',   bizu: 'Trás, trás, trás sua irmã pra mim!'),
  Toque(id: 4,  nome: 'Direita volver',    audio: 'direita-volver.aac',    bizu: 'Ooolha...ali!'),
  Toque(id: 5,  nome: 'Esquerda volver',   audio: 'esquerda-volver.aac',   bizu: 'Olha, olha, olha... ali!'),
  Toque(id: 6,  nome: 'Meia volta volver', audio: 'meiavolta.aac',         bizu: 'Nunca vi mulher solteira... pari'),
  Toque(id: 7,  nome: 'Voltas volver',     audio: 'voltas-volver.aac'),
  Toque(id: 8,  nome: 'Ombro arma',        audio: 'ombro-arma.aac',        bizu: 'Faz ombro arma'),
  Toque(id: 9,  nome: 'Descansar arma',    audio: 'descansar-arma.aac',    bizu: 'Descansar... arma!'),
  Toque(id: 10, nome: 'Cruzar arma',       audio: 'cruzar-arma.aac',       bizu: 'Cruzar, cruzar, cruzar!'),
  Toque(id: 11, nome: 'Ordinário marche',  audio: 'ordinario-marche.aac'),
  Toque(id: 12, nome: 'Marcar passo',      audio: 'marcar-passo.aac'),
  Toque(id: 13, nome: 'Acelerado',         audio: 'acelerado.aac'),
  Toque(id: 14, nome: 'À vontade',         audio: 'avontade.aac'),
  Toque(id: 15, nome: 'Cessar à vontade',  audio: 'cessar-avontade.aac'),
  Toque(id: 16, nome: 'Cobrir',            audio: 'cobrir.aac',            bizu: 'Soldaaado vamos cobrir!'),
  Toque(id: 17, nome: 'Firme',             audio: 'firme.aac',             bizu: 'Ai meu Deus que dor!'),
  Toque(id: 18, nome: 'Alto',              audio: 'alto.aac',              bizu: 'Faz alto!'),
  Toque(id: 19, nome: 'Última forma',      audio: 'ultima-forma.aac'),
  Toque(id: 20, nome: 'Formatura',         audio: 'formatura.aac'),
  Toque(id: 21, nome: 'Fora de forma',     audio: 'fora-de-forma.aac'),
  Toque(id: 22, nome: 'Olhar a direita',   audio: 'olhar-direita.aac'),
  Toque(id: 23, nome: 'Olhar à esquerda',  audio: 'olhar-esquerda.aac'),
  Toque(id: 24, nome: 'Olhar frente',      audio: 'olhar-frente.aac',      bizu: 'Em frente vamos olhar!'),
  Toque(id: 25, nome: 'Bandeira',          audio: 'bandeira.aac'),
  Toque(id: 26, nome: 'Marcha batida',     audio: 'marcha-batida.aac'),
  Toque(id: 27, nome: 'Alvorada',          audio: 'alvorada.aac'),
];
