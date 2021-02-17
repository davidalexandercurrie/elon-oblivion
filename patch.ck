me.sourceDir() + "/elon.txt" => string filename;
FileIO fio;
fio.open( filename, FileIO.READ );
string str;
int timeStamps[0];
while( fio => str )
{
    str <= IO.newline();
    str => string s;
    timeStamps << Std.atoi(s);
}
me.sourceDir() + "/words.txt" => string words;
FileIO wordTxt;
wordTxt.open( words, FileIO.READ );
string wordString;
string wordArray[0];
while( wordTxt => wordString )
{
    wordString <= IO.newline();
    wordString => string word;
    wordArray << word;
}
// for(0 => int i; i < timeStamps.size(); i++){
//   <<<timeStamps[i]>>>;
// }

me.sourceDir() + "elon.wav" => string path;
me.sourceDir() + "oblivionLoop.wav" => string oPath;


// the patch
SndBuf buf => JCRev r => HPF hpf => dac;
SndBuf oBuf => JCRev oR => dac;
oR.mix(0.3);
hpf.freq(100);
0 => r.mix;
// load the file
path => buf.read;
oPath => oBuf.read;
1 => buf.rate;
1 => buf.loop;
1 => oBuf.rate;
1 => oBuf.loop;

1 => int timeStampIndex;
1 => int playing;
500.0 => float divider;
spork~ setOblivionRate();
1 => buf.gain;
while(timeStampIndex < timeStamps.cap()){
  timeStamps[timeStampIndex] * 22.05 $ int => buf.pos;
  timeStamps[timeStampIndex+1] - timeStamps[timeStampIndex] => int wordDuration;
  setDivider(wordDuration);
  wordDuration / divider => float playBackRate;
  playBackRate => buf.rate;
  <<<wordArray[timeStampIndex], "">>>;
  divider::ms => now;
  timeStampIndex++;
}

fun void setDivider(int wordDuration){
  if(wordDuration < 375){
    250 => divider;
  }else if(wordDuration < 625){
    500 => divider;
  }else if (wordDuration < 875){
    750 => divider;
  }else if (wordDuration < 1500){
    1000 => divider;
  }else if (wordDuration < 2500){
    2000 => divider;
  }else if (wordDuration < 3500){
    3000 => divider;
  }
}

fun void setOblivionRate(){
  while(true){
    if(oBuf.rate() < 1000 / divider){
      oBuf.rate() + 0.0001 => oBuf.rate;
    }else {
      oBuf.rate() - 0.0001 => oBuf.rate;
    }
    1::ms => now;
  }
}

5::second => now;





