#set page("a4", flipped: true, columns: 3, margin: 0.5cm)
#set columns(gutter: 0.25cm)
#set text(font: "Noto Sans", size: 10pt)
#set par(leading: 0.15cm)

#let module(body) = {
    set text(weight: "bold", fill: blue)
    [#body --- ]
}

#let keyword(body) = {
    set text(style: "italic", fill: fuchsia)
    [#body]
}
#let num = [n#box(stack(
    dir: ttb,
    spacing: 1pt,
    text(size: 0.6em)[o],
    line(length: 0.35em, stroke: 0.6pt),
    v(0.3em)
))
]

#module[Word Representations]
#keyword[One-hot-encoding] issues: 1. orthogonal definitions; every word is
equidistant from every other word, 2. high-dimensionality (and sparse), 3.
fixed vocabulary; must use `UNK` token to represent unknown words.
#keyword[WordNet]: a large, manually-curated database grouping synonyms into
synsets with definitions and usage examples. Downsides: manual, no rare/new
meanings, vectors still orthogonal & equidistan, homonym disambiguation.
#keyword[Distributional Hypothesis]: similar words occur in similar contexts.
#keyword[Word2Vec]: learn embeddings. Architectures: CBOW & skip-gram.
Training strategy: hierarchical softmax & negative sampling.
#keyword[CBOW]: predict $w_t$ based on surrounding context words.
#keyword[Skip-gram]: predict context words based on $w_t$. The model is a
neural network with one hidden layer:
$p(w_(t+j) | w_t)="softmax"(x W_"in"W_"out"$), where $x$ is the one-hot encoded
target word and the output is a probability distribution over the vocabulary
that captures $p(w_"context" | w_"target")$. In skip-gram we have several
outputs for each context word. The matrix $W_"in"$ maps the input to the
embedding for that target word.
The loss function for skip-gram is $1/T sum_(t = 1)^T
sum_(-c <= j <= c, j != 0) log p(w_(t+j)|w_t; theta)$.
#keyword[Negative sampling]: vocabularies could be large in size, making
softmax calculation expensive. Instead we can use binary classification to
distinguish context words. We take random negative samples that aren't in the
context. Then maximise the prob. that positive samples are predicted true
and negative samples are predicted false. We pick $k$ negative samples,
$k in [5, 20]$. The model now has $|V|$ classifiers, defined by sigmoids.
Frequency sampling better than random: $p(w_i)= (f(w_i)^(3/4)) /
(sum_w' f(w')^(3/4))$.
Downsides to word embeddings: need large data to train, low quality for rare
words, antonyms have similar distributions, cannot capture different meanings
of a word.
#keyword[Byte-pair encoding]: 1. Start with vocabulary of individual
characters. 2. Find which vocabulary pair occurs most frequently. 3. Add that
combination as a new vocabulary item. 4. Merge all such occurrences in the
corpus. 5. Repeat until desired number of merges (hyperparameter) have been
performed. We append each word with an end-of-word symbol `_`, because it
distinguishes suffixes and tells us where to insert spaces when reassembling
text.
#keyword[TF-IDF]: Term Frequency Inverse Document Frequency
$"TF"_(w,d) = "count"(w, d) / sum_w' "count"(w', d)$
$"IDF"_(w,D)=log (|D|) / (|{d in D : w in d}|)$. Upweights words important in a
document, downweights words that appear everywhere.

#module[Classification]
Bayes' Rule: $P(y|x) = (P(x|y)P(y)) / (P(x))$. Because $P(x)$ is fixed,
$hat(y) = "argmax"_y P(y|x) = "argmax"_y P(x|y) P(y)$.
#keyword[Add-one smoothing]: multiplication with zero probabilities collapse
the final result to 0. This can happen if we encounter an unseen word.
$P(x_i|y)=("count"(x_i,y)+1)/(sum_(x in V) "count"(x,y) + 1)$
Can take too much probability mass from likely occurrences, so try +$k$
smoothing with a smaller $k$.
#keyword[Binary Naive Bayes]: ignore duplicates of a feature in each instance.
#keyword[Controlling for negation]: append `NOT_` after any logical negation
until the next punctuation mark.
Naive Bayes problems: all features are considered equally important,
conditional independence is an assumption, context of words not considered,
new words cannot be used.
#keyword[Cross-Entropy Loss]: measures how close predicted distribution $Q$
is to actual distribution $P$; $H(P,Q)=-sum_i P(y_i)log Q(y_i)$.
#keyword[Sigmoid]: $1 / (1+e^(-x))$.
#keyword[Softmax]: $g(z_i)= (e^(z_i)) / (sum_j e^(z_j))$
#keyword[Document representation]: variable-size documents can be represented
as the average of their embeddings, but this loses positional information.
#keyword[RNNs]: process sequential data. $h_(t+1)=tanh(W h_t + U x_t)$. The
output at time $t$ is $y_t = W_(h y) h_t + B_y$.
Limitations: vanishing gradient problem. $tanh$ and $"sigmoid"$ derivatives are
between 0 and 1, and 0 and 0.25. Repeated multiplication means gradients
disappear, so model is less able to learn from earlier inputs. Also, gradient
for earlier layers involve repeated multiplication of the same weight matrix
$W$. Depending on the dominant eigenvalue, this can cause it to vanish or
explode.
#keyword[CNNs]: filter width = embedding dimension, filter height = 2 to 5
tokens. CNNs perform well if the task involves key phrase recognition.
RNNs better understand longer-range dependencies.

#module[Language Models]
#keyword[N-gram modelling]: find the most probable next word using
$P(w_n | w_1^(n-1))$ by counting occurences. $N$-gram approximation:
$approx P(w_n | w_(n-N-1)^(n-1))$
#keyword[Perplexity)] = $P(w_1,w_2,...,w_n)^(-1/n)$. We aim to minimise
perplexity. Perplexity = $e^H$, where $H$ is CE loss.
#keyword[Extrinsic] evaluation: choose LM that works best on downstream task.
Perplexity is #keyword[intrinsic].

#module[Neural Language Models]
#keyword[Backoff Smoothing]: $P(w_i|w^(i-1)_k) = 0$, use
$0.4P(w_i|w^(i-1)_(k+1))$ recursively instead.
#keyword[Interpolation]: combine evidence from different n-grams:
$lambda_1 P(w_i "trigram") + lambda_2 P(w_i "bigram") + lambda_3 P(w_i)$
where $sum_i lambda_i = 1$
#keyword[Bidirectional RNNs]: concatenate hidden states of a forward and
backward RNN. This allows the model to see into the future.
#keyword[Multi-layered RNNs]: hidden states from one layer become inputs of
another.
#keyword[LSTMs]: cell states provide long-term memory that helps against
vanishing/exploding gradient because (1) additive formula $arrow.r$ no repeated
multiplicaiton and (2) forget gate allows model to choose when to preserve
and vanish gradients. $c_t = f_t dot.o c_(t-1) + i_t dot.o g_t$ and
$h_t=o_t dot.o tanh c_t$, where $g_t = tanh(W x_t + W h_(t-1) + b)$ and
$i_t, f_t, o_t = sigma(W x_t + W h_(t-1) + b)$.
#keyword[GRUs]: reset and update gate, no cell state.
$g_t = tanh(W x_t + r_t(W h_(t-1) + b))$ and
$h_t = (1-z_t)g_t + z_t h_(t-1)$.

#module[Machine Translation]
#keyword[Statistical MT]: Uses a parallel dataset.
Model $p(t|s)$ using Bayes' Theorem.
Maximise $p(t)p(s|t)$ - $p(t)$ is the #keyword[language model], $p(s|t)$
is the #keyword[translation model]. Downsides: sentence alignment, word
alignment, statistical anomalies, idioms, out-of-vocab words.
#keyword[RNNs]: bidirectional encoder which feeds into a unidirectional
encoder. Encoded representation is context vector $c$ - could be final hidden
state of encoder, or mean of all hidden states.
Use #keyword[teacher forcing] to avoid accumulation of errors - can do
at every time-step, or a proportion of time-steps. Loss function:
$-sum_(t=1)^T log p(hat(y)_t|y_(<t),c)$ where $hat(y)$ are decoder outputs.
Downsides: encoder representation has fixed capacity; gets worse for longer
sentences.
#keyword[Attention]: additive/MLP, multiplicative, self-attention.
MLP: $c_t=sum_(i=1)^I alpha_i h_i$.
$alpha_i$ comes from #keyword[alignment function]:
$e_i = v^top tanh(W s_(t-1) + U h_i)$ where $s$ is previous decoder hidden
state. $v, W, U$ are learnable. Compute $e_i in RR$ for every encoder hidden
state, then normalise using softmax to get $alpha_i$ scores.
#keyword[BLEU score]:
$"BLEU-4" = "BP"(product_n^4 p_n)^(1/4)$, modified precision
$p_n = "total unique overlap"_n / ("total "n"-grams")$,
$"BP"$ = brevity penalty, e.g. $min(1, c/r)$ where $c$ = candidate length,
$r$ = reference length. Good: fast/cheap, language-independent, corpus-level
correlation. Bad: no synonyms, no recall, no grammar/fluency, unreliable at
sentence-level.
#keyword[Chr-F]: character n-gram $F_beta$ score, character-level handles
morphologically rich languages.
#keyword[TER]: translation error rate = Number of edits / number of words in
reference.
#keyword[ROUGE]: evaluating summaries. ROUGE-$n$ is $F$-score of $n$-gram
counts over references and candidates. ROUGE-$L$ is $F$-score of longest
common subsequence.
#keyword[METEOR]: $m$ unigrams matched by (1) exact match, (2) stem match, (3)
synonym match. Precision and recall calculated from these matches.
$F_"mean" = (10P R)/(9P + R)$. Unigrams grouped into least #num of
chunks, $"ch"$. Penalty = $gamma ("ch"/m)^beta$.
$"METEOR" = F_"mean" (1 - "Pen")$
#keyword[BertScore]: convert candidate and reference to BERT embeddings, then
pairwise cosine similarity of each token.
#keyword[Greedy decoding]: output most likely word at each timestep. Fast,
but doesn't look into future.
#keyword[Beam search]: keep $k$ most likely paths at each timestep.
#keyword[Temperature sampling]: change distribution using temperature param.
Divide logits by $T$, then apply softmax and sample distribution.
Low temperature #sym.arrow.r peaky dist., close to deterministic. High $T$
#sym.arrow.r close to uniform dist.
#keyword[Back translation]: train a model translating in reverse direction.
Use outputs of that model to train final model. Adds noise.
#keyword[Batching/padding rules]: group similar-length sentences together
in a batch, train model on smaller/simpler sentences first.

#module[Transformers]
#grid(
   columns: 2,
   image("transformer.png"),
   [
    #keyword[Self Attention]:
    $"Attention"(Q,K,V) = "softmax"((Q K^top) / (sqrt(d_k)))V$. Large values of
    $d_k$ yields dot products large in magnitude, pushing softmax into regions
    with extremely small gradients, so a scaling factor is applied. The output
    is a set of values, weighted by similarity between keys and queries.
    Queries, keys and values are learnable weight matrices.
    $V in RR^(S times d_h)$ where $S$ is sentence length, $d_h$ is attention
    vector dimension.
   ],
)
#keyword[Multi-head self attention]: perform self-attention head $n$ times. We
simply concatenate each head's output before applying the output projection.
#keyword[Layer normalisation]: normalises the features of *one* sample in
*one* batch. $B = {x_1, ..., x_N} mapsto {"LN"(hat(x)_1), ..., "LN"(hat(x)_N)}$
where $hat(x)=(x-mu)/sigma$ and $"LN"(x)=gamma dot.o x + beta$;
$x_n, gamma, beta in RR^d$
#keyword[Residual connections]: shortcut for information flow. Prevent
vanishing gradient, network learns $delta$. Layer output is $F(x) + x$ instead
of $F(x)$.
#keyword[Position-wise FNN]: all tokens independently pass through the same
two-layer network. $"FNN"(x) = max(0, x W_1 + b)W_2 + b_2$. This is where
knowledge is stored.
#keyword[Positional encoding]: returns $"embedding" + "pos_enc"_i$.
$"PE"_("pos", 2i) = sin("pos" / 10000^((2i)/d))$
