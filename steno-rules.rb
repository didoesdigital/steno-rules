module StenoRules

  def self.three_or_more_characters?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.length >= 3
    return false
  end

  def self.one_syllable?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    translation.downcase!
    return false if translation == "mysql"
    return false if translation == "genre"
    return false if translation == "genres"
    return true if translation.length <= 3
    translation.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '') # e.g. scored
    translation.sub!(/^y/, '') # e.g. year
    return true if (translation.scan(/[aeiouy]{1,2}/).size) == 1
    return false
  end

  def self.one_or_two_syllables?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    translation.downcase!
    return true if translation.length <= 3
    translation.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '') # e.g. scored
    translation.sub!(/^y/, '') # e.g. year
    return true if (translation.scan(/[aeiouy]{1,2}/).size) < 3
    return false
  end

  def self.more_than_one_syllable?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    translation.downcase!
    translation.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '') # e.g. scored
    translation.sub!(/^y/, '') # e.g. year
    return true if (translation.scan(/[aeiouy]{1,2}/).size) > 1
    return false
  end

  def self.one_of_AOEU?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU][AOEU][^AOEU]/)
    return false
  end

  def self.only_short_i?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU]EU[^AOEU]/)
    return false
  end

  def self.short_vowel?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU](A|O|E|U|EU)[^AOEU]/)
    return false
  end

  def self.long_vowel?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU](AEU|AOE|AOEU|OE|AOU)[^AOEU]/)
    return false
  end

  def self.diphthongs?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU](AU|OU|OEU)[^AOEU]/)
    return false
  end

  def self.vowel_disambiguators?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[^AOEU](AE|AO)[^AOEU]/)
    return false
  end

  def self.vowel?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[AOEU]+/)
    return false
  end

  def self.single_stroke?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return false if outline.match(/\//)
    return true
  end

  def self.multi_stroke?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/\//)
    return false
  end

  def self.forced_word_ending?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/^[^\/]*\/SP-S$/)
    return false
  end

  def self.one_consonant_on_each_side?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[STKPWHR].+[FRPBLGTSDZ]/)
    return false
  end

  def self.lhs_consonant_with_multiple_keys?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/(TK|PW|HR|TP|TKPW|SR|TPH|PH|SKWR|KWR).+/) && !outline.match(/\*/)
    return true if outline.match(/([^AOEU]S\*|KR\*|KW\*|KP\*|STKPW\*).+/) && !outline.match(/[TKHAOEUFRBLGSDZ]\*/)
    return false
  end

  def self.rhs_consonant_with_multiple_keys?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/.+(BG|PB|PL|PBLG)/) && !outline.match(/\*/)
    return true if outline.match(/.+(\*T|\*PL|\*LG|\*PBG)/) && !outline.match(/\*[SKWHRAOEUFBGDZ]/)
    return false
  end

  def self.digraphs?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if (outline.match(/TH.+/) && translation.match(/th/))
    return true if (outline.match(/(KH|SH).+/) && translation.match(/(ch|sh)/) && !translation.match(/cl/))
    return true if (outline.match(/.+(FP|RB|PBG)/) && translation.match(/(ch|sh|ng)/) && !translation.match(/cl/))
    return false
  end

  def self.compound_clusters?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/\*.*PBG/) && translation.match(/nk/)
    return false if translation == "img"
    return false if translation == "programme" # ignore UK English only spelling
    return true if outline.match(/.+FRB/)
    return true if outline.match(/.+FRPB/)
    return true if outline.match(/.+LG/)
    return true if outline.match(/.+GS/) && (translation.match(/ion[s]?$/) || translation.match(/ean[s]?$/) || translation.match(/ian[s]?$/)) && !translation.match(/cs$/) && !translation.match(/x$/) # match ocean, caution, and Asian, but not pics or tex
    return true if outline.match(/.+BGS/) && translation.match(/ction[s]?$/) && translation.match(/[^g]/) && !translation.match(/cs$/) && !translation.match(/x$/) # match function, and not pics or tex
    return true if outline.match(/.+\*.*PL/) && translation.match(/mp/)
    return false
  end

  def self.some_consonants?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/[STKPWHR]{2,}/) || outline.match(/[FRPBLGTSDZ]{2,}/)
    return false
  end

  def self.apostrophes?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if (translation.match(/[']/))
    return false
  end

  def self.double_letters?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if (translation.match(/([A-Za-z])\1/)) && !(translation.match(/([A-Za-z])\1\1/))
    return false
  end

  def self.double_consonants?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if (translation.match(/([bcdfghjklmnpqrstvwxyz])\1/)) && !(translation.match(/([bcdfghjklmnpqrstvwxyz])\1\1/))
    return false
  end

  def self.double_vowels?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if (translation.match(/(aa|ee|ii|oo|uu)/)) && !(translation.match(/(aaa|eee|iii|ooo|uuu)/))
    return false
  end

  def self.contractions_plurals_or_possessives?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if ((translation.match(/[']/)) && !translation.match(/[A-Z]+/))
    return true if ((translation.match(/[']/)) && translation.match(/I'/))
    return false
  end

  def self.non_nkro_keyboards?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/^[STKPWHRAO\*EUFBLGDZ]{1,6}$/)
    return false
  end

  def self.simple_steno_keys?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    # S*|*T|*PBG|*LG|
    return false if outline.match(/(TK|PW|HR|TP|TKPW|SR|BG|TPH|PB|PH|PL|SKWR|KWR|PB|PL|PBLG|TH|KH|FP|SH|RB|PBG|APL|FRPB|FRB|LG|GS|BGS)/)
    return false if outline.match(/(KR)/)
    return false if outline.match(/(KW)/)
    return false if outline.match(/(FRP)/)
    return false if outline.match(/(EGT)/)
    return true
  end

  def self.unstressed_vowels?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    translation.downcase!
    translation.sub!(/(?:[^laeiouy]e)$/, '') # e.g. scored
    translation.sub!(/^y/, '') # e.g. year
    return false if (translation.scan(/[aeiouy]{1,2}/).size) == 1
    return true
  end

  def self.inversion?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if (outline.match(/FL/) && translation.match(/(lf|lv)/))
    return true if (outline.match(/PL/) && translation.match(/lp/))
    return true if (outline.match(/FR/) && translation.match(/rs/)) # 'offers': OFRS
    return true if (outline.match(/STK/) && translation.match(/(dis|des)/))
    return true if (outline.match(/GD/) && translation.match(/ding/))
    return true if (outline.match(/WE/) && translation.match(/ew/) && !translation.match(/we/)) # "SWEG": "sewing", but not 'farewell': TPAER/WEL
    return true if (outline.match(/RL/) && translation.match(/ler/)) # "RORL": "roller",
    return true if (outline.match(/TD/) && translation.match(/d.*t/) && !translation.match(/d.*d/)) # "ETD": "edit", but not 'adopted': A/TKOPTD
    return true if (outline.match(/LT/) && translation.match(/t.*l/) && !translation.match(/l.*l/) && !translation.match(/t.*t/)) # "PORLT": "portal", but not 'developmental': SREPLT/AL, or 'nationality': TPHAT/ALT
    return true if (outline.match(/LT/) && translation.match(/t.?ly$/) && !translation.match(/alt.*l/)) # 'absolutely': SHRAOULT, but not 'alternatively': AULT/TEUFL, or 'alternately': ALT/TPHAT/HREU
    return false
  end

  def self.condensed_stroke?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if (outline.match(/\/TK-LS\//))
    return false
  end

  def self.ef_as_vee_or_ess?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if (outline.match(/F/) && translation.match(/[aeiouy]+.*[sv]/))
    return false
  end

  def self.fingerspelling?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    # exclude lowercase "i"
    return true if translation.match(/^[A-Za-z]{1}$/) && !translation.match(/^[i]$/)
    return false
  end

  FINGERSPELLING_KEYS = %w[A* A*P PW* PW*P KR* KR*P TK* TK*P *EU *EUP *E *EP TP* TP*P TKPW* TKPW*P H* H*P SKWR* SKWR*P K* K*P HR* HR*P PH* PH*P TPH* TPH*P O* O*P P* P*P KW* KW*P R* R*P S* S*P T* T*P *U *UP SR* SR*P W* W*P KP* KP*P KWR* KWR*P STKPW* STKPW*P].to_set
  def self.fingerspelled_words?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    outline.split("/").all? { |stroke| FINGERSPELLING_KEYS.include?(stroke) }
  end

  # puts fingerspelled_words?('"*EP/R*/*EU/KR*/S*/S*/O*/TPH*": "Ericsson",')

  def self.numbers?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.match(/[0-9]/)
    return false
  end

  def self.punctuation?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.match(/[[:punct:]]+/)
    return true if translation.match(/[\p{S}]+/)
    return false
  end

  def self.contains_uppercase?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.match(/[A-Z]+/)
    return false
  end

  def self.all_uppercase?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.match(/^[A-Z]+$/)
    return false
  end

  def self.dictionary_format?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.match(/({\^|\^}|{\#|-\||{\*|{\<|{\>|{MODE|{PLOVER|{\.}|{\?}|{\!|{:}|{ }|{,}|{.|{-|{&|%}|{;})/)
  end

  def self.disambiguating_brief?(line)
    return true if (line.match(/"HEURD": "hired",/))
    return true if (line.match(/"WEUFS": "wives",/))
    return false
  end

  def self.philly_shift?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if (outline.match(/TDZ/)) # 'amidst': A/PHEUTDZ
    return true if (outline.match(/TSD/))
    return true if (outline.match(/TSZ/))
    return true if (outline.match(/SDZ/))
    return false
  end

  def self.short_translations?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.length < 6
    return false
  end

  def self.long_translations?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.length > 16
    return false
  end

  def self.long_words?(line)
    translation = line.match(/.*": "(.+)"/).captures[0]
    return true if translation.length > 16 && !translation.include?(' ') && !translation.include?('-')
    return false
  end

  def self.brief?(line)
    return true if (line.match(/"HEP": "help",/))
    return true if (line.match(/"HEPS": "helps",/))
    return true if (line.match(/"SURG": "surgeon",/))
    return true if (line.match(/"SUBT": "subject",/))
    return true if (line.match(/"PROBS": "problems",/))
    return true if (line.match(/"SESZ": "access",/))
    return true if (line.match(/"SEPS": "accepts",/))
    return true if (line.match(/"SKUS": "discuss",/))
    return true if (line.match(/"TRAF": "transfer",/))
    return true if (line.match(/"PROEUR": "prior",/))
    return true if (line.match(/"TAOULT": "actually",/))
    return true if (line.match(/"PHAEB": "maybe",/))

    outline = line.match(/"(.+)": ".+"/).captures[0]

    return true if outline.match(/^[STKPWHR]{1,2}[-AOEU]+[^FRPBLGTSDZ]$/)
    return true if outline.match(/^[^STKPWHR][-AOEU]+[FRPBLGTSDZ]{1,2}$/)
    return true if outline.match(/^[AOEU]$/)
    return true if outline.match(/^[STKPWHR]{1,2}-[FRPBLGTSDZ]{1,2}$/)
    return false
  end

  def self.star?(line)
    outline = line.match(/"(.+)": ".+"/).captures[0]
    return true if outline.match(/\*/)
    return false
  end

end
