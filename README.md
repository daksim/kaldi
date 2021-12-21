# NISP Costumed Kaldi

See [here](https://github.com/kaldi-asr/kaldi) for complete information of Kaldi.

## Install Kaldi

You can just run `install.sh` in our own server.

If `install.sh` fails, please install Kaldi yourself through the following steps:

- go to `tools/`, run 

  ```shell
  extras/check_dependencies.sh
  make
  ```

- go to `src/`, run

  ```shell
  ./configure --shared
  make depend
  make
  ```

## Check installation

Go to `egs/yesno/s5/`, run `run.sh`.

## Train mini-LibriSpeech Kaldi

Prepare speech [data](https://www.openslr.org/31/) in `path_to_minilibrispeech_audios`, where

```
<path_to_minilibrispeech_audios>
└── LibriSpeech
    ├── speakerID
    │   ├── paragraphID
    │   │   ├── speakerID-paragraphID-uttranceID.flac
    │   │   ├── ......
    │   │   └── speakerID-paragraphID.trans.txt
    │   └── ......
    └── ......
```

Go to `egs/mini_librispeech/s5`.

Change line 26 of the `steps/nnet3/chain/train.py` to define the serial number of GPUs used.

Start training by 

```shell
./run.sh <path_to_minilibrispeech_audios>
```

## Test the model

Decode an audio file `path_to_test_wav_audio.wav` in `egs/mini_librispeech/s5` by

```shell
../../../src/online2bin/online2-wav-nnet3-latgen-faster \
    --do-endpointing=false \
    --online=false \
    --config=egs/mini_librispeech/s5/exp/chain/tdnn1f_sp_online/conf/online.conf \
    --max-active=7000 \
    --beam=15.0 \
    --lattice-beam=6.0 \
    --acoustic-scale=1.0 \
    --word-symbol-table=egs/mini_librispeech/s5/exp/chain/tree_sp/graph_tgsmall/words.txt \
    egs/mini_librispeech/s5/exp/chain/tdnn1f_sp/final.mdl \
    egs/mini_librispeech/s5/exp/chain/tree_sp/graph_tgsmall/HCLG.fst \
    'ark:echo utter1 utter1|' \
    'scp:echo utter1 <path_to_test_wav_audio.wav>|' \
    ark:/dev/null
```

To get the WER on the dev set of mini-LibriSpeech, run

```shell
local/chain/compare_wer.sh --online exp/chain/tdnn1f_sp 2>/dev/null
```

the output is like

```shell
# local/chain/compare_wer.sh --online exp/chain/tdnn1f_sp
# System                tdnn1f_sp
#WER dev_clean_2 (tgsmall)      14.51
#             [online:]         14.52
#WER dev_clean_2 (tglarge)      10.59
#             [online:]         10.60
# Final train prob        -0.0723
# Final valid prob        -0.0915
# Final train prob (xent)   -2.2869
# Final valid prob (xent)   -2.3976
# Num-params                 4172512
```

