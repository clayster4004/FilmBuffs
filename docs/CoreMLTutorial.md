# CoreML Tutorial

Hey, thanks for joining! To give a quick introduction, I am going to assume you have a baseline knowledge of Swift, so this tutorial is not going to go over syntactical analysis by any means. This tutorial will be more focused on how to:

- Find data
- Train a model
- Implement it into a preexisting project

*Hint*: If you want to follow along using my app, feel free to fork this repository!

---

## Table of Contents

i. Finding Data\
ii. Converting the data into a CreateML readable structure\
iii. Getting Started with Create ML\
iv. Training Your Data\
v. Using Your Model\
vi. Congratulations!

---

i. **Finding Data**

In this section, you figure out specifically what kind of data you are looking for. You're in luck because I have a couple of websites that host TONS of free data for us to use!

### Option 1: [Hugging Face](https://huggingface.co)
This option has a bunch of pretrained models as well as datasets for people to train their own models.

### Option 2: [Kaggle](https://www.kaggle.com)
Like Hugging Face, Kaggle offers a large variety of pretrained models and free datasets.

Take some time here looking at everything and figuring out what works for you. For this tutorial, I am going to use the **celebrity-1000 dataset** created by [tonyassi on Hugging Face](https://huggingface.co/datasets/tonyassi/celebrity-1000).

This dataset is small enough to quickly train yet large enough to have some working functionality to it.

#### Downloading the Dataset:
1. Navigate to the dataset's [Files and Versions](https://huggingface.co/datasets/tonyassi/celebrity-1000) tab.
   ![Files and Versions Tab](https://github.com/user-attachments/assets/a7df554b-06f5-4196-b70d-5742a8c9be98)
2. Select **data**.
   ![Data](https://github.com/user-attachments/assets/c7012ff6-51d8-44d5-aab3-038d9387dbfe)
3. Click the download button and save it anywhere you'd like.
   ![Download Button](https://github.com/user-attachments/assets/02f8b755-b78c-48bf-819d-2400076a4bdb)

---

ii. **Converting the Data into a CreateML-Readable Structure**

This YAML metadata describes the dataset structure:
<details>
<summary>Click to expand YAML</summary>

```yaml
dataset_info:
  features:
    - name: image
      dtype: image
    - name: label
      dtype:
        class_label:
          names:
            '0': Aaron Eckhart
            '1': Aaron Paul
            '2': Aaron Rodgers
            '3': Aaron Taylor-Johnson
            '4': Abbi Jacobson
            '5': Abhishek Bachchan
            '6': Abigail Breslin
            '7': Abigail Spencer
            '8': Adam Brody
            '9': Adam Devine
            '10': Adam Driver
            '11': Adam Lambert
            '12': Adam Levine
            '13': Adam Sandler
            '14': Adam Scott
            '15': Adele
            '16': Adrian Grenier
            '17': Adèle Exarchopoulos
            '18': Aidan Gillen
            '19': Aidan Turner
            '20': Aishwarya Rai
            '21': Aja Naomi King
            '22': Alden Ehrenreich
            '23': Aldis Hodge
            '24': Alec Baldwin
            '25': Alex Morgan
            '26': Alex Pettyfer
            '27': Alex Rodriguez
            '28': Alexander Skarsgård
            '29': Alexandra Daddario
            '30': Alfre Woodard
            '31': Alia Shawkat
            '32': Alice Braga
            '33': Alice Eve
            '34': Alicia Keys
            '35': Alicia Vikander
            '36': Alison Brie
            '37': Allison Janney
            '38': Allison Williams
            '39': Alyson Hannigan
            '40': Amanda Peet
            '41': Amanda Seyfried
            '42': Amandla Stenberg
            '43': Amber Heard
            '44': America Ferrera
            '45': Amy Adams
            '46': Amy Poehler
            '47': Amy Schumer
            '48': Ana de Armas
            '49': Andie MacDowell
            '50': Andrew Garfield
            '51': Andrew Lincoln
            '52': Andrew Scott
            '53': Andy Garcia
            '54': Andy Samberg
            '55': Andy Serkis
            '56': Angela Bassett
            '57': Angelina Jolie
            '58': Anna Camp
            '59': Anna Faris
            '60': Anna Kendrick
            '61': Anna Paquin
            '62': AnnaSophia Robb
            '63': Annabelle Wallis
            '64': Anne Hathaway
            '65': Anne Marie
            '66': Anne-Marie
            '67': Ansel Elgort
            '68': Anson Mount
            '69': Anthony Hopkins
            '70': Anthony Joshua
            '71': Anthony Mackie
            '72': Antonio Banderas
            '73': Anya Taylor-Joy
            '74': Ariana Grande
            '75': Armie Hammer
            '76': Ashley Judd
            '77': Ashton Kutcher
            '78': Aubrey Plaza
            '79': Auli'i Cravalho
            '80': Awkwafina
            '81': Barack Obama
            '82': Bella Hadid
            '83': Bella Thorne
            '84': Ben Barnes
            '85': Ben Mendelsohn
            '86': Ben Stiller
            '87': Ben Whishaw
            '88': Benedict Cumberbatch
            '89': Benedict Wong
            '90': Benicio del Toro
            '91': Bill Gates
            '92': Bill Hader
            '93': Bill Murray
            '94': Bill Pullman
            '95': Bill Skarsgård
            '96': Billie Eilish
            '97': Billie Lourd
            '98': Billy Crudup
            '99': Billy Porter
            '100': Blake Lively
            '101': Bob Odenkirk
            '102': Bonnie Wright
            '103': Boyd Holbrook
            '104': Brad Pitt
            '105': Bradley Cooper
            '106': Brendan Fraser
            '107': Brian Cox
            '108': Brie Larson
            '109': Brittany Snow
            '110': Bryan Cranston
            '111': Bryce Dallas Howard
            '112': Busy Philipps
            '113': Caitriona Balfe
            '114': Cameron Diaz
            '115': Camila Cabello
            '116': Camila Mendes
            '117': Cardi B
            '118': Carey Mulligan
            '119': Carla Gugino
            '120': Carrie Underwood
            '121': Casey Affleck
            '122': Cate Blanchett
            '123': Catherine Keener
            '124': Catherine Zeta-Jones
            '125': Celine Dion
            '126': Chace Crawford
            '127': Chadwick Boseman
            '128': Channing Tatum
            '129': Charlie Cox
            '130': Charlie Day
            '131': Charlie Hunnam
            '132': Charlie Plummer
            '133': Charlize Theron
            '134': Chiara Ferragni
            '135': Chiwetel Ejiofor
            '136': Chloe Bennet
            '137': Chloe Grace Moretz
            '138': Chloe Sevigny
            '139': Chloë Grace Moretz
            '140': Chloë Sevigny
            '141': Chris Cooper
            '142': Chris Evans
            '143': Chris Hemsworth
            '144': Chris Martin
            '145': Chris Messina
            '146': Chris Noth
            '147': Chris O'Dowd
            '148': Chris Pine
            '149': Chris Pratt
            '150': Chris Tucker
            '151': Chrissy Teigen
            '152': Christian Bale
            '153': Christian Slater
            '154': Christina Aguilera
            '155': Christina Applegate
            '156': Christina Hendricks
            '157': Christina Milian
            '158': Christina Ricci
            '159': Christine Baranski
            '160': Christoph Waltz
            '161': Christopher Plummer
            '162': Christopher Walken
            '163': Cillian Murphy
            '164': Claire Foy
            '165': Clive Owen
            '166': Clive Standen
            '167': Cobie Smulders
            '168': Colin Farrell
            '169': Colin Firth
            '170': Colin Hanks
            '171': Connie Britton
            '172': Conor McGregor
            '173': Constance Wu
            '174': Constance Zimmer
            '175': Courteney Cox
            '176': Cristiano Ronaldo
            '177': Daisy Ridley
            '178': Dak Prescott
            '179': Dakota Fanning
            '180': Dakota Johnson
            '181': Damian Lewis
            '182': Dan Stevens
            '183': Danai Gurira
            '184': Dane DeHaan
            '185': Daniel Craig
            '186': Daniel Dae Kim
            '187': Daniel Day-Lewis
            '188': Daniel Gillies
            '189': Daniel Kaluuya
            '190': Daniel Mays
            '191': Daniel Radcliffe
            '192': Danny DeVito
            '193': Darren Criss
            '194': Dave Bautista
            '195': Dave Franco
            '196': Dave Grohl
            '197': Daveed Diggs
            '198': David Attenborough
            '199': David Beckham
            '200': David Duchovny
            '201': David Harbour
            '202': David Oyelowo
            '203': David Schwimmer
            '204': David Tennant
            '205': David Thewlis
            '206': Dax Shepard
            '207': Debra Messing
            '208': Demi Lovato
            '209': Dennis Quaid
            '210': Denzel Washington
            '211': Dermot Mulroney
            '212': Dev Patel
            '213': Diane Keaton
            '214': Diane Kruger
            '215': Diane Lane
            '216': Diego Boneta
            '217': Diego Luna
            '218': Djimon Hounsou
            '219': Dolly Parton
            '220': Domhnall Gleeson
            '221': Dominic Cooper
            '222': Dominic Monaghan
            '223': Dominic West
            '224': Don Cheadle
            '225': Donald Glover
            '226': Donald Sutherland
            '227': Donald Trump
            '228': Dua Lipa
            '229': Dwayne "The Rock" Johnson
            '230': Dwayne Johnson
            '231': Dylan O'Brien
            '232': Ed Harris
            '233': Ed Helms
            '234': Ed Sheeran
            '235': Eddie Murphy
            '236': Eddie Redmayne
            '237': Edgar Ramirez
            '238': Edward Norton
            '239': Eiza Gonzalez
            '240': Eiza González
            '241': Elijah Wood
            '242': Elisabeth Moss
            '243': Elisha Cuthbert
            '244': Eliza Coupe
            '245': Elizabeth Banks
            '246': Elizabeth Debicki
            '247': Elizabeth Lail
            '248': Elizabeth McGovern
            '249': Elizabeth Moss
            '250': Elizabeth Olsen
            '251': Elle Fanning
            '252': Ellen DeGeneres
            '253': Ellen Page
            '254': Ellen Pompeo
            '255': Ellie Goulding
            '256': Elon Musk
            '257': Emile Hirsch
            '258': Emilia Clarke
            '259': Emilia Fox
            '260': Emily Beecham
            '261': Emily Blunt
            '262': Emily Browning
            '263': Emily Deschanel
            '264': Emily Hampshire
            '265': Emily Mortimer
            '266': Emily Ratajkowski
            '267': Emily VanCamp
            '268': Emily Watson
            '269': Emma Bunton
            '270': Emma Chamberlain
            '271': Emma Corrin
            '272': Emma Mackey
            '273': Emma Roberts
            '274': Emma Stone
            '275': Emma Thompson
            '276': Emma Watson
            '277': Emmanuelle Chriqui
            '278': Emmy Rossum
            '279': Eoin Macken
            '280': Eric Bana
            '281': Ethan Hawke
            '282': Eva Green
            '283': Eva Longoria
            '284': Eva Mendes
            '285': Evan Peters
            '286': Evan Rachel Wood
            '287': Evangeline Lilly
            '288': Ewan McGregor
            '289': Ezra Miller
            '290': Felicity Huffman
            '291': Felicity Jones
            '292': Finn Wolfhard
            '293': Florence Pugh
            '294': Florence Welch
            '295': Forest Whitaker
            '296': Freddie Highmore
            '297': Freddie Prinze Jr.
            '298': Freema Agyeman
            '299': Freida Pinto
            '300': Freya Allan
            '301': Gabrielle Union
            '302': Gael Garcia Bernal
            '303': Gael García Bernal
            '304': Gal Gadot
            '305': Garrett Hedlund
            '306': Gary Oldman
            '307': Gemma Arterton
            '308': Gemma Chan
            '309': Gemma Whelan
            '310': George Clooney
            '311': George Lucas
            '312': Gerard Butler
            '313': Giancarlo Esposito
            '314': Giannis Antetokounmpo
            '315': Gigi Hadid
            '316': Gillian Anderson
            '317': Gillian Jacobs
            '318': Gina Carano
            '319': Gina Gershon
            '320': Gina Rodriguez
            '321': Ginnifer Goodwin
            '322': Gisele Bundchen
            '323': Glenn Close
            '324': Grace Kelly
            '325': Greg Kinnear
            '326': Greta Gerwig
            '327': Greta Scacchi
            '328': Greta Thunberg
            '329': Gugu Mbatha-Raw
            '330': Guy Ritchie
            '331': Gwen Stefani
            '332': Gwendoline Christie
            '333': Gwyneth Paltrow
            '334': Hafthor Bjornsson
            '335': Hailee Steinfeld
            '336': Hailey Bieber
            '337': Haley Joel Osment
            '338': Halle Berry
            '339': Hannah Simone
            '340': Harrison Ford
            '341': Harry Styles
            '342': Harvey Weinstein
            '343': Hayden Panettiere
            '344': Hayley Atwell
            '345': Helen Hunt
            '346': Helen Mirren
            '347': Helena Bonham Carter
            '348': Henry Cavill
            '349': Henry Golding
            '350': Hilary Swank
            '351': Himesh Patel
            '352': Hozier
            '353': Hugh Bonneville
            '354': Hugh Dancy
            '355': Hugh Grant
            '356': Hugh Jackman
            '357': Hugh Laurie
            '358': Ian Somerhalder
            '359': Idris Elba
            '360': Imelda Staunton
            '361': Imogen Poots
            '362': Ioan Gruffudd
            '363': Isabella Rossellini
            '364': Isabelle Huppert
            '365': Isla Fisher
            '366': Issa Rae
            '367': Iwan Rheon
            '368': J.K. Rowling
            '369': J.K. Simmons
            '370': Jack Black
            '371': Jack Reynor
            '372': Jack Whitehall
            '373': Jackie Chan
            '374': Jada Pinkett Smith
            '375': Jaden Smith
            '376': Jaimie Alexander
            '377': Jake Gyllenhaal
            '378': Jake Johnson
            '379': Jake T. Austin
            '380': James Cameron
            '381': James Corden
            '382': James Franco
            '383': James Marsden
            '384': James McAvoy
            '385': James Norton
            '386': Jamie Bell
            '387': Jamie Chung
            '388': Jamie Dornan
            '389': Jamie Foxx
            '390': Jamie Lee Curtis
            '391': Jamie Oliver
            '392': Jane Fonda
            '393': Jane Krakowski
            '394': Jane Levy
            '395': Jane Lynch
            '396': Jane Seymour
            '397': Janelle Monáe
            '398': January Jones
            '399': Jared Leto
            '400': Jason Bateman
            '401': Jason Clarke
            '402': Jason Derulo
            '403': Jason Isaacs
            '404': Jason Momoa
            '405': Jason Mraz
            '406': Jason Schwartzman
            '407': Jason Segel
            '408': Jason Statham
            '409': Jason Sudeikis
            '410': Javier Bardem
            '411': Jay Baruchel
            '412': Jay-Z
            '413': Jeff Bezos
            '414': Jeff Bridges
            '415': Jeff Daniels
            '416': Jeff Goldblum
            '417': Jeffrey Dean Morgan
            '418': Jeffrey Donovan
            '419': Jeffrey Wright
            '420': Jemima Kirke
            '421': Jenna Coleman
            '422': Jenna Fischer
            '423': Jenna Ortega
            '424': Jennifer Aniston
            '425': Jennifer Connelly
            '426': Jennifer Coolidge
            '427': Jennifer Esposito
            '428': Jennifer Garner
            '429': Jennifer Hudson
            '430': Jennifer Lawrence
            '431': Jennifer Lopez
            '432': Jennifer Love Hewitt
            '433': Jenny Slate
            '434': Jeremy Irons
            '435': Jeremy Renner
            '436': Jeremy Strong
            '437': Jerry Seinfeld
            '438': Jesse Eisenberg
            '439': Jesse Metcalfe
            '440': Jesse Plemons
            '441': Jesse Tyler Ferguson
            '442': Jesse Williams
            '443': Jessica Alba
            '444': Jessica Biel
            '445': Jessica Chastain
            '446': Jessica Lange
            '447': Jessie Buckley
            '448': Jim Carrey
            '449': Jim Parsons
            '450': Joan Collins
            '451': Joan Cusack
            '452': Joanne Froggatt
            '453': Joaquin Phoenix
            '454': Jodie Comer
            '455': Jodie Foster
            '456': Joe Jonas
            '457': Joe Keery
            '458': Joel Edgerton
            '459': Joel Kinnaman
            '460': Joel McHale
            '461': John Boyega
            '462': John C. Reilly
            '463': John Cena
            '464': John Cho
            '465': John Cleese
            '466': John Corbett
            '467': John David Washington
            '468': John Goodman
            '469': John Hawkes
            '470': John Krasinski
            '471': John Legend
            '472': John Leguizamo
            '473': John Lithgow
            '474': John Malkovich
            '475': John Mayer
            '476': John Mulaney
            '477': John Oliver
            '478': John Slattery
            '479': John Travolta
            '480': John Turturro
            '481': Johnny Depp
            '482': Johnny Knoxville
            '483': Jon Bernthal
            '484': Jon Favreau
            '485': Jon Hamm
            '486': Jonah Hill
            '487': Jonathan Groff
            '488': Jonathan Majors
            '489': Jonathan Pryce
            '490': Jonathan Rhys Meyers
            '491': Jordan Peele
            '492': Jordana Brewster
            '493': Joseph Fiennes
            '494': Joseph Gordon-Levitt
            '495': Josh Allen
            '496': Josh Brolin
            '497': Josh Gad
            '498': Josh Hartnett
            '499': Josh Hutcherson
            '500': Josh Radnor
            '501': Jude Law
            '502': Judy Dench
            '503': Judy Greer
            '504': Julia Garner
            '505': Julia Louis-Dreyfus
            '506': Julia Roberts
            '507': Julia Stiles
            '508': Julian Casablancas
            '509': Julian McMahon
            '510': Julianna Margulies
            '511': Julianne Hough
            '512': Julianne Moore
            '513': Julianne Nicholson
            '514': Juliette Binoche
            '515': Juliette Lewis
            '516': Juno Temple
            '517': Jurnee Smollett
            '518': Justin Bartha
            '519': Justin Bieber
            '520': Justin Hartley
            '521': Justin Herbert
            '522': Justin Long
            '523': Justin Theroux
            '524': Justin Timberlake
            '525': KJ Apa
            '526': Kaitlyn Dever
            '527': Kaley Cuoco
            '528': Kanye West
            '529': Karl Urban
            '530': Kat Dennings
            '531': Kate Beckinsale
            '532': Kate Bosworth
            '533': Kate Hudson
            '534': Kate Mara
            '535': Kate Middleton
            '536': Kate Upton
            '537': Kate Walsh
            '538': Kate Winslet
            '539': Katee Sackhoff
            '540': Katherine Heigl
            '541': Katherine Langford
            '542': Katherine Waterston
            '543': Kathryn Hahn
            '544': Katie Holmes
            '545': Katie McGrath
            '546': Katy Perry
            '547': Kaya Scodelario
            '548': Keanu Reeves
            '549': Keegan-Michael Key
            '550': Keira Knightley
            '551': Keke Palmer
            '552': Kelly Clarkson
            '553': Kelly Macdonald
            '554': Kelly Marie Tran
            '555': Kelly Reilly
            '556': Kelly Ripa
            '557': Kelvin Harrison Jr.
            '558': Keri Russell
            '559': Kerry Washington
            '560': Kevin Bacon
            '561': Kevin Costner
            '562': Kevin Hart
            '563': Kevin Spacey
            '564': Ki Hong Lee
            '565': Kiefer Sutherland
            '566': Kieran Culkin
            '567': Kiernan Shipka
            '568': Kim Dickens
            '569': Kim Kardashian
            '570': Kirsten Dunst
            '571': Kit Harington
            '572': Kourtney Kardashian
            '573': Kristen Bell
            '574': Kristen Stewart
            '575': Kristen Wiig
            '576': Kristin Davis
            '577': Krysten Ritter
            '578': Kyle Chandler
            '579': Kylie Jenner
            '580': Kylie Minogue
            '581': Lady Gaga
            '582': Lake Bell
            '583': Lakeith Stanfield
            '584': Lamar Jackson
            '585': Lana Del Rey
            '586': Laura Dern
            '587': Laura Harrier
            '588': Laura Linney
            '589': Laura Prepon
            '590': Laurence Fishburne
            '591': Laverne Cox
            '592': LeBron James
            '593': Lea Michele
            '594': Lea Seydoux
            '595': Lee Pace
            '596': Leighton Meester
            '597': Lena Headey
            '598': Leonardo Da Vinci
            '599': Leonardo DiCaprio
            '600': Leslie Mann
            '601': Leslie Odom Jr.
            '602': Lewis Hamilton
            '603': Liam Hemsworth
            '604': Liam Neeson
            '605': Lili Reinhart
            '606': Lily Aldridge
            '607': Lily Allen
            '608': Lily Collins
            '609': Lily James
            '610': Lily Rabe
            '611': Lily Tomlin
            '612': Lin-Manuel Miranda
            '613': Linda Cardellini
            '614': Lionel Messi
            '615': Lisa Bonet
            '616': Lisa Kudrow
            '617': Liv Tyler
            '618': Lizzo
            '619': Logan Lerman
            '620': Lorde
            '621': Lucy Boynton
            '622': Lucy Hale
            '623': Lucy Lawless
            '624': Lucy Liu
            '625': Luke Evans
            '626': Luke Perry
            '627': Luke Wilson
            '628': Lupita Nyong'o
            '629': Léa Seydoux
            '630': Mackenzie Davis
            '631': Madelaine Petsch
            '632': Mads Mikkelsen
            '633': Mae Whitman
            '634': Maggie Gyllenhaal
            '635': Maggie Q
            '636': Maggie Siff
            '637': Maggie Smith
            '638': Mahershala Ali
            '639': Mahira Khan
            '640': Maisie Richardson-Sellers
            '641': Maisie Williams
            '642': Mandy Moore
            '643': Mandy Patinkin
            '644': Marc Anthony
            '645': Margaret Qualley
            '646': Margot Robbie
            '647': Maria Sharapova
            '648': Marion Cotillard
            '649': Marisa Tomei
            '650': Mariska Hargitay
            '651': Mark Hamill
            '652': Mark Ruffalo
            '653': Mark Strong
            '654': Mark Wahlberg
            '655': Mark Zuckerberg
            '656': Marlon Brando
            '657': Martin Freeman
            '658': Martin Scorsese
            '659': Mary Elizabeth Winstead
            '660': Mary J. Blige
            '661': Mary Steenburgen
            '662': Mary-Louise Parker
            '663': Matt Bomer
            '664': Matt Damon
            '665': Matt LeBlanc
            '666': Matt Smith
            '667': Matthew Fox
            '668': Matthew Goode
            '669': Matthew Macfadyen
            '670': Matthew McConaughey
            '671': Matthew Perry
            '672': Matthew Rhys
            '673': Matthew Stafford
            '674': Max Minghella
            '675': Maya Angelou
            '676': Maya Hawke
            '677': Maya Rudolph
            '678': Megan Fox
            '679': Megan Rapinoe
            '680': Meghan Markle
            '681': Mel Gibson
            '682': Melanie Lynskey
            '683': Melissa Benoist
            '684': Melissa McCarthy
            '685': Melonie Diaz
            '686': Meryl Streep
            '687': Mia Wasikowska
            '688': Michael B. Jordan
            '689': Michael C. Hall
            '690': Michael Caine
            '691': Michael Cera
            '692': Michael Cudlitz
            '693': Michael Douglas
            '694': Michael Ealy
            '695': Michael Fassbender
            '696': Michael Jordan
            '697': Michael Keaton
            '698': Michael Pena
            '699': Michael Peña
            '700': Michael Phelps
            '701': Michael Shannon
            '702': Michael Sheen
            '703': Michael Stuhlbarg
            '704': Michelle Dockery
            '705': Michelle Monaghan
            '706': Michelle Obama
            '707': Michelle Pfeiffer
            '708': Michelle Rodriguez
            '709': Michelle Williams
            '710': Michelle Yeoh
            '711': Michiel Huisman
            '712': Mila Kunis
            '713': Miles Teller
            '714': Milla Jovovich
            '715': Millie Bobby Brown
            '716': Milo Ventimiglia
            '717': Mindy Kaling
            '718': Miranda Cosgrove
            '719': Miranda Kerr
            '720': Mireille Enos
            '721': Molly Ringwald
            '722': Morgan Freeman
            '723': Mélanie Laurent
            '724': Naomi Campbell
            '725': Naomi Harris
            '726': Naomi Scott
            '727': Naomi Watts
            '728': Naomie Harris
            '729': Nas
            '730': Natalie Dormer
            '731': Natalie Imbruglia
            '732': Natalie Morales
            '733': Natalie Portman
            '734': Nathalie Emmanuel
            '735': Nathalie Portman
            '736': Nathan Fillion
            '737': Naya Rivera
            '738': Neil Patrick Harris
            '739': Neil deGrasse Tyson
            '740': Neve Campbell
            '741': Neymar Jr.
            '742': Nicholas Braun
            '743': Nicholas Hoult
            '744': Nick Jonas
            '745': Nick Kroll
            '746': Nick Offerman
            '747': Nick Robinson
            '748': Nicole Kidman
            '749': Nikolaj Coster-Waldau
            '750': Nina Dobrev
            '751': Noah Centineo
            '752': Noomi Rapace
            '753': Norman Reedus
            '754': Novak Djokovic
            '755': Octavia Spencer
            '756': Odessa Young
            '757': Odette Annable
            '758': Olivia Colman
            '759': Olivia Cooke
            '760': Olivia Holt
            '761': Olivia Munn
            '762': Olivia Wilde
            '763': Oprah Winfrey
            '764': Orlando Bloom
            '765': Oscar Isaac
            '766': Owen Wilson
            '767': Pablo Picasso
            '768': Patrick Dempsey
            '769': Patrick Mahomes
            '770': Patrick Stewart
            '771': Patrick Wilson
            '772': Paul Bettany
            '773': Paul Dano
            '774': Paul Giamatti
            '775': Paul McCartney
            '776': Paul Rudd
            '777': Paul Wesley
            '778': Paula Patton
            '779': Pedro Almodóvar
            '780': Pedro Pascal
            '781': Penelope Cruz
            '782': Penélope Cruz
            '783': Pete Davidson
            '784': Peter Dinklage
            '785': Phoebe Dynevor
            '786': Phoebe Waller-Bridge
            '787': Pierce Brosnan
            '788': Portia de Rossi
            '789': Priyanka Chopra
            '790': Quentin Tarantino
            '791': Rachel Bilson
            '792': Rachel Brosnahan
            '793': Rachel McAdams
            '794': Rachel Weisz
            '795': Rafe Spall
            '796': Rainn Wilson
            '797': Ralph Fiennes
            '798': Rami Malek
            '799': Rashida Jones
            '800': Ray Liotta
            '801': Ray Romano
            '802': Rebecca Ferguson
            '803': Rebecca Hall
            '804': Reese Witherspoon
            '805': Regina Hall
            '806': Regina King
            '807': Renee Zellweger
            '808': Renée Zellweger
            '809': Rhys Ifans
            '810': Ricardo Montalban
            '811': Richard Armitage
            '812': Richard Gere
            '813': Richard Jenkins
            '814': Richard Madden
            '815': Ricky Gervais
            '816': Ricky Martin
            '817': Rihanna
            '818': Riley Keough
            '819': Rita Ora
            '820': River Phoenix
            '821': Riz Ahmed
            '822': Rob Lowe
            '823': Robert Carlyle
            '824': Robert De Niro
            '825': Robert Downey Jr.
            '826': Robert Pattinson
            '827': Robert Sheehan
            '828': Robin Tunney
            '829': Robin Williams
            '830': Roger Federer
            '831': Rooney Mara
            '832': Rosamund Pike
            '833': Rosario Dawson
            '834': Rose Byrne
            '835': Rose Leslie
            '836': Roselyn Sanchez
            '837': Ruby Rose
            '838': Rupert Grint
            '839': Russell Brand
            '840': Russell Crowe
            '841': Russell Wilson
            '842': Ruth Bader Ginsburg
            '843': Ruth Wilson
            '844': Ryan Eggold
            '845': Ryan Gosling
            '846': Ryan Murphy
            '847': Ryan Phillippe
            '848': Ryan Reynolds
            '849': Ryan Seacrest
            '850': Salma Hayek
            '851': Sam Claflin
            '852': Sam Heughan
            '853': Sam Rockwell
            '854': Sam Smith
            '855': Samara Weaving
            '856': Samuel L. Jackson
            '857': Sandra Bullock
            '858': Sandra Oh
            '859': Saoirse Ronan
            '860': Sarah Gadon
            '861': Sarah Hyland
            '862': Sarah Jessica Parker
            '863': Sarah Michelle Gellar
            '864': Sarah Paulson
            '865': Sarah Silverman
            '866': Sarah Wayne Callies
            '867': Sasha Alexander
            '868': Scarlett Johansson
            '869': Scott Speedman
            '870': Sean Bean
            '871': Sebastian Stan
            '872': Selena Gomez
            '873': Selma Blair
            '874': Serena Williams
            '875': Seth MacFarlane
            '876': Seth Meyers
            '877': Seth Rogen
            '878': Shailene Woodley
            '879': Shakira
            '880': Shania Twain
            '881': Sharlto Copley
            '882': Shawn Mendes
            '883': Shia LaBeouf
            '884': Shiri Appleby
            '885': Shohreh Aghdashloo
            '886': Shonda Rhimes
            '887': Sienna Miller
            '888': Sigourney Weaver
            '889': Simon Baker
            '890': Simon Cowell
            '891': Simon Pegg
            '892': Simone Biles
            '893': Sofia Boutella
            '894': Sofia Vergara
            '895': Sophie Turner
            '896': Sophie Wessex
            '897': Stanley Tucci
            '898': Stephen Amell
            '899': Stephen Colbert
            '900': Stephen Curry
            '901': Stephen Dorff
            '902': Sterling K. Brown
            '903': Sterling Knight
            '904': Steve Carell
            '905': Steven Yeun
            '906': Susan Sarandon
            '907': Taika Waititi
            '908': Taraji P. Henson
            '909': Taron Egerton
            '910': Taylor Hill
            '911': Taylor Kitsch
            '912': Taylor Lautner
            '913': Taylor Schilling
            '914': Taylor Swift
            '915': Teresa Palmer
            '916': Terrence Howard
            '917': Tessa Thompson
            '918': Thandie Newton
            '919': The Weeknd
            '920': Theo James
            '921': Thomas Brodie-Sangster
            '922': Thomas Jane
            '923': Tiger Woods
            '924': Tilda Swinton
            '925': Tim Burton
            '926': Tim Cook
            '927': Timothee Chalamet
            '928': Timothy Olyphant
            '929': Timothy Spall
            '930': Timothée Chalamet
            '931': Tina Fey
            '932': Tobey Maguire
            '933': Toby Jones
            '934': Toby Kebbell
            '935': Toby Regbo
            '936': Tom Brady
            '937': Tom Brokaw
            '938': Tom Cavanagh
            '939': Tom Cruise
            '940': Tom Ellis
            '941': Tom Felton
            '942': Tom Hanks
            '943': Tom Hardy
            '944': Tom Hiddleston
            '945': Tom Holland
            '946': Tom Hollander
            '947': Tom Hopper
            '948': Tom Selleck
            '949': Toni Collette
            '950': Tony Hale
            '951': Topher Grace
            '952': Tracee Ellis Ross
            '953': Tyra Banks
            '954': Tyrese Gibson
            '955': Uma Thurman
            '956': Usain Bolt
            '957': Uzo Aduba
            '958': Vanessa Hudgens
            '959': Vanessa Kirby
            '960': Vera Farmiga
            '961': Victoria Pedretti
            '962': Viggo Mortensen
            '963': Vin Diesel
            '964': Vince Vaughn
            '965': Vincent Cassel
            '966': Vincent D'Onofrio
            '967': Vincent Kartheiser
            '968': Viola Davis
            '969': Walton Goggins
            '970': Wes Anderson
            '971': Wes Bentley
            '972': Whoopi Goldberg
            '973': Will Ferrell
            '974': Will Poulter
            '975': Willem Dafoe
            '976': William Jackson Harper
            '977': William Shatner
            '978': Winona Ryder
            '979': Woody Harrelson
            '980': Yara Shahidi
            '981': Yvonne Strahovski
            '982': Zac Efron
            '983': Zach Braff
            '984': Zach Galifianakis
            '985': Zachary Levi
            '986': Zachary Quinto
            '987': Zayn Malik
            '988': Zazie Beetz
            '989': Zendaya
            '990': Zoe Kazan
            '991': Zoe Kravitz
            '992': Zoe Saldana
            '993': Zoey Deutch
            '994': Zooey Deschanel
            '995': Zoë Kravitz
            '996': Zoë Saldana
  splits:
    - name: train
      num_bytes: 193671657.464
      num_examples: 18184
  download_size: 190510261
  dataset_size: 193671657.464
configs:
  - config_name: default
    data_files:
      - split: train
        path: data/train-*
```

</details>

### Saving Data from parquet to csv

<details>
<summary>Click to expand Python Code</summary>
   
```python
import pandas as pd

# Read the Parquet file
df = pd.read_parquet('train-00000-of-00001.parquet')

# Save it as a CSV file
df.to_csv('celebrity-1000.csv', index=False)

print("Parquet file successfully converted to CSV.")
```

</details>

### Organizing Images:
Another script for organizing images into folders based on their labels:
<details>
<summary>Click to expand Python Code</summary>
   
```python
import yaml
import os
import pandas as pd
from PIL import Image
import io
import ast
import unicodedata
import re
from tqdm import tqdm

# Function to sanitize folder names
def slugify(value):
    value = str(value)
    value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore').decode('ascii')
    value = re.sub(r'[^\w\s-]', '', value).strip()
    value = re.sub(r'[-\s]+', '_', value)
    return value

# Load the YAML file
yaml_file = 'dataset_info.yaml'  # Replace with the path to your YAML file
with open(yaml_file, 'r') as f:
    yaml_data = yaml.safe_load(f)

# Extract label-to-name mapping from YAML
label_to_celebrity = yaml_data['dataset_info']['features'][1]['dtype']['class_label']['names']

# Base directory to save images
base_dir = 'CelebImages'
os.makedirs(base_dir, exist_ok=True)

# Load the CSV file containing image data
csv_file = 'celebrity-1000.csv'  # Replace with your CSV file path
df = pd.read_csv(csv_file)

# Ensure 'image' and 'label' columns exist
if 'image' not in df.columns or 'label' not in df.columns:
    print("CSV file must contain 'image' and 'label' columns.")
    exit(1)

# Organize images into folders based on celebrity names
for idx, row in tqdm(df.iterrows(), total=len(df)):
    label = str(row['label'])  # Ensure label is treated as a string
    image_data_str = row['image']  # Ensure this contains valid image data in string format

    try:
        if label not in label_to_celebrity:
            print(f"Label {label} not found in label_to_celebrity mapping.")
            continue

        # Parse the image data
        image_dict = ast.literal_eval(image_data_str)
        image_bytes = image_dict['bytes']

        # Open the image from bytes
        image = Image.open(io.BytesIO(image_bytes))

        # Get the celebrity name and create the folder
        celebrity_name = slugify(label_to_celebrity[label])
        celebrity_folder = os.path.join(base_dir, celebrity_name)
        os.makedirs(celebrity_folder, exist_ok=True)

        # Save the image
        filename = f"{celebrity_name}_{idx}.jpg"
        filepath = os.path.join(celebrity_folder, filename)
        image.save(filepath)
        print(f"Saved image {idx} to {filepath}")

    except Exception as e:
        print(f"Failed to process image at index {idx}: {e}")
        continue

print("Images saved successfully.")
```

</details>

By the end of this, you should have a folder labeled **"CelebImages"** with subfolders containing the pictures.

---

iii. **Getting Started with Create ML**

1. Press cmd + Spacebar on your machine and type in "Create ML" Navigate to the folder of your choice and click on "New Document".
<img width="798" alt="Screenshot 2024-11-26 at 11 09 51 AM" src="https://github.com/user-attachments/assets/61c4ef4f-86c2-4d34-b193-c0239c20addf">

2. Leave the Selection on Image Classification and hit the "next" button
<img width="1050" alt="ImgClass" src="https://github.com/user-attachments/assets/e200c51c-2813-4e31-a2dc-04a561669110">

3. Name it whatever you'd like and hit "next"
<img width="1050" alt="NameML" src="https://github.com/user-attachments/assets/15aadb32-a59c-4e13-9a09-f786963215e1">

If you've done everything correctly your screen should look something like this
<img width="1383" alt="YouDidIt" src="https://github.com/user-attachments/assets/7933c3a6-37f0-49bf-8a64-dd74a6969f68">


iv. **Training your data**

Thankfully training data has never been easier. Start by selecting the data Folder "CelebImages" that was generated via the above python script
<img width="1381" alt="Select" src="https://github.com/user-attachments/assets/c5996b85-c4cc-4153-9ddb-3d59a9cc583f">

Select the number of iterations (for my project I did 25 iterations). Click the "train" button in the top left corner of the screen.
<img width="1382" alt="Train" src="https://github.com/user-attachments/assets/5f5640ac-b48d-461d-b14f-9eabdf54c3a2">

Once the data is done training save the mlmodel file to your machine. This involves navigating to the output tab and selecting the "Get" button
<img width="1366" alt="Screenshot 2024-11-29 at 2 07 42 PM (2)" src="https://github.com/user-attachments/assets/df61adac-0244-44e3-96d5-61bcf57dda48">

Save this file to the project you want to use the model in.

Congratulations you just trained a model!


v. **Using your model**

Since this tutorial is based on the CreateML/CoreML functionality I am going to go forward assuming that you have either forked my repository or have an application of your own that you want to implement this type of model into. In essence I am going to give code examples and explain how I added this model into my prexisting application that already has the view and viewmodel functionality implemented to take photos from your application.

That being said I will do a brief overview of how I implemented this model into my source code, with those stated functionalities

***Creating a view for the camera***  
In this section I am going to do a quick overview of how I set up my CameraView.swift file

To start I created the file and added the navigator as an EnvironmentObject and the CameraViewModel as a ObservedObject (created later in the tutoiral)
The CameraViewModel will hold the logic for handling the camera, cropping faces, and running the CoreML model
```swift
import SwiftUI

struct CameraView: View {
    // Observes the viewModel which contains the logic
    @ObservedObject var viewModel: CameraViewModel
    // Accept the navigator as an environment object; can be used here
    @EnvironmentObject var navi: MyNavigator
```

Next I created a basic body for the view with a button to open up the camera on your device. This button triggers the isShowingCamera flag in the viewModel; enabling the camera interface
```swift
   var body: some View {
        VStack {
            // Singular open camera button on the page
            Button("Open Camera") {
                viewModel.isShowingCamera = true // Sets the "show camera" flag
            }
            .padding()
```

This section will display the captured image on the screen upon successfully taking a photo.
```swift
               // This view displays the captured picture *if available*
               if let image = viewModel.capturedImage {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 200, height: 200)
               }
```

Since the model was trained on just the cropped faces, the viewModel will need to have the functionality to crop the picture taken to just include the face
```swift
               // Display the cropped face image *if available*
               if let croppedFace = viewModel.croppedFaceImage {
                   Text("Detected Face:")
                       .padding(.top)
                   Image(uiImage: croppedFace) // Shows the cropped face in a smaller window
                       .resizable()
                       .scaledToFit()
                       .frame(width: 150, height: 150)
                       .padding()
               } else {
                   if viewModel.capturedImage != nil {
                       Text("No face detected or still processing...")
                           .foregroundColor(.gray)
                           .padding(.top)
                   }
               }

           }
```

I created a file ImagePicker.swift that is necessary to specifically bringing up the camera, additionally after the viewModel tries to detect the face we need a prompt to appear with that result
```swift
            // This is needed to actually display the camera when the flag is set to true
           .sheet(isPresented: $viewModel.isShowingCamera) {
               // ImagePicker is used to displaying the camera
               ImagePicker(sourceType: .camera) { image in
                   viewModel.handleCapturedImage(image)
               }
           }
           // When the picture is taken and available an alert will pop up running the facial detection.
           .alert(isPresented: $viewModel.showConfirmationAlert) {
               Alert(
                   title: Text("Is this \(viewModel.identifiedPersonName ?? "the person")?"),
                   primaryButton: .default(Text("Yes")) {
                       // If the person is correct the page will navigate and search for their information to display
                       viewModel.performManualSearch(navi: navi)
                   },
                   secondaryButton: .cancel(Text("No"))
               )
           }
       }
   }
```

***Creating ImagePicker.swift***  
ImagePicker.swift is necessary to allow the user to capture images in a SwiftUI app. SwiftUI does not natively support image picking so this file acts as a bridge between SwiftUI and the UIKit framework.

presentationMode is the variable used to manage whether the UIImagePickerController is shown or not. The source type defines that we are using the camera functionality. The completion handler is a closure that handles the captured image by the user. 
```swift
import SwiftUI
import UIKit

// Protocol for UIKit
struct ImagePicker: UIViewControllerRepresentable {
    // This is needed to dismiss the camera view post picture taken
    @Environment(\.presentationMode) var presentationMode

    // Defines that it will be opening camera
    var sourceType: UIImagePickerController.SourceType = .camera
    // Allows that picture taken to be accessed
    var completionHandler: (UIImage) -> Void
```

This creates the instance of UIImagePickerController, ensures it's source is the camera, and defines the coordinator as the delegate to handler the picker events like image selection. The makeCoordinator function creates the coordinator instance the handle events for the UIImagePickerController
```swift
/// Configures UI image picker controller
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // Initializes a new UIImagePickerController
        let picker = UIImagePickerController()
        // Sets the pickers source type to camera as opposed to photo lib and deligator to handle events
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }

    /// This function will be used to update the view if need be *unused*
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // TODO: Needed to conform to protocol
    }

    /// Coordinator needed to handle events like image selection and cancellation
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
```

This coordinator is essentially used to connect the UIKit elements back to SwiftUI. It references the ImagePicker instance that created this coordinator.
The imagePickerController function handles where the user selects the image and sends it back to the UI. Additionlly, the imagePickerControllerDidCancel function holds the functionality that allows the user the cancel the picker.
```swift
/// Coordinator class to handle UIImagePickerControllerDelegate methods
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Reference to ImagePicker instance
        let parent: ImagePicker

        init(_ picker: ImagePicker) {
            self.parent = picker
        }

        /// Handle the selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extracts the selected image
            if let uiImage = info[.originalImage] as? UIImage {
                // Sends image back to SwiftUI
                parent.completionHandler(uiImage)
            }
            // Returns user to previous screen
            parent.presentationMode.wrappedValue.dismiss()
        }

        // Handle cancellation if user backs out
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
```

***Creating CameraViewModel.swift***  
The CameraViewModel holds the meat of the logic in using our model!

This snippet has code that handles the image that the user captures, ensures it is sitting in portriat mode (as opposed to landscape), and crops just the face from the image. Additionally, this function calls the recognition function where we will be using our model against the captured image.
```swift
import SwiftUI
import Vision
import UIKit
import CoreML

class CameraViewModel: ObservableObject {
    @Published var isShowingCamera = false             // Boolean for if the camera is showing
    @Published var capturedImage: UIImage? = nil       // Holds captured image
    @Published var croppedFaceImage: UIImage? = nil    // To hold the cropped face
    @Published var identifiedPersonName: String? = nil // Used to hold identity
    @Published var showConfirmationAlert = false       // Controls whether to show the confirmation alert

    // Function to handle the captured image
    func handleCapturedImage(_ image: UIImage) {
        let fixedImage = image.fixedOrientation()  // Ensures vertical image
        self.capturedImage = fixedImage
        // If there is a face in the image crop it to just see that face
        detectAndCropFace(from: fixedImage) { croppedImage in
            DispatchQueue.main.async {
                if let croppedImage = croppedImage {
                    self.croppedFaceImage = croppedImage.fixedOrientation()  // Ensures vertical image
                    self.performRecognition(on: croppedImage) // Try to identify the person
                } else {
                    self.croppedFaceImage = nil
                }
            }
        }
    }
```

This snippet of code is where you are using the MLModel you trained. First of all it resizes the image to the same size image as the training data. Then you defined the model using CoreML. It is important to note this name I am using is what I named my model in CreateML. Additionally, this model is in my project in a folder called "Models". You need to then convert the image into a "pixelBuffer" to be able to use the model for recognition. Finally, you make a prediction and set the confimation flag so your UI knows to display the prediction.
```swift
/// Core ML usage to try to idetifity the person in the image based on a trained model
    private func performRecognition(on image: UIImage) {
        // Resize the image to best match my training data
        guard let resizedImage = image.resized(to: CGSize(width: 256, height: 256)) else {
            print("Failed to resize image")
            return
        }
        
        // Define the model I am using
        guard let model = try? FacialDetectionv1_0(configuration: MLModelConfiguration()) else {
            print("Failed to load model")
            return
        }
        
        // This is required for Core ML model inputs
        guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            print("Failed to convert UIImage to CVPixel Buffer")
            return
        }
        
        // This code may run an error
        do {
            // Insert the pixel buffer into the model to try and make a perdiction
            let prediction = try model.prediction(image: pixelBuffer)
            // Set the identified person as the output of the model
            self.identifiedPersonName = prediction.target
            self.showConfirmationAlert = true
        } catch {
            print("Error making prediction: \(error.localizedDescription)")
        }
    }
```

This section is for use in my demo application, but it essentially uses the name to make a database call to then display information about the identified celebrity.
```swift
/// Manually initiate search based on identified person name
    func performManualSearch(navi: MyNavigator) {
        // Take the persons name, like "Adam_Sandler" and take out the "_"
        if let name = identifiedPersonName {
            let formattedName = name.replacingOccurrences(of: "_", with: " ")
            
            // Search for their information via the API
            NetworkManager.shared.searchMoviesAndActors(query: formattedName) { result in
                DispatchQueue.main.async {
                    switch result {
                    // If they are found navigate to their view; Success!
                    case .success(let results):
                        if let matchedActor = results.first(where: { $0.mediaType == "person" && $0.name == formattedName }) {
                            navi.navigate(to: .AboutActor(matchedActor.id))
                        } else {
                            print("Could not find actor details for \(formattedName)")
                        }
                    case .failure(let error):
                        print("Error searching for actor: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

```

To finish out this tutorial I will include the cropping functions I used to ensure the captured photo is similar to the training data used.
```swift
// Function to detect and crop face using Vision framework
    private func detectAndCropFace(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        // Built in swift function to detect faces in photos
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            // Uses the first detected face
            guard let results = request.results as? [VNFaceObservation], let faceObservation = results.first else {
                print("No faces detected.")
                completion(nil)
                return
            }
            
            // Crop the face from the image
            let boundingBox = faceObservation.boundingBox
            let croppedImage = self.cropImage(image, to: boundingBox)
            completion(croppedImage)
        }
        
        // Convert UIImage to CGImage (so the framework can work with the image)
        guard let cgImage = image.cgImage else {
            print("Unable to convert UIImage to CGImage.")
            completion(nil)
            return
        }
        
        // Perform face detection request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            // Call the handler with the detected face for processing
            try handler.perform([faceDetectionRequest])
        } catch {
            print("Failed to perform face detection: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    /// Function used to crop the face to match the models data
    private func cropImage(_ image: UIImage, to boundingBox: CGRect) -> UIImage? {
        // Set enlargement factors for different sides
        let topEnlargementFactor: CGFloat = 0.25  // More focus on adding to the top of the head
        let overallEnlargementFactor: CGFloat = 0.2  // General enlargement for sides and bottom

        // Original bounding box properties
        let originalWidth = image.size.width * boundingBox.width
        let originalHeight = image.size.height * boundingBox.height
        let originalX = image.size.width * boundingBox.origin.x
        let originalY = image.size.height * (1 - boundingBox.origin.y) - originalHeight

        // Calculate the new enlarged width and height (so we can "blow up" the photo)
        let newWidth = originalWidth * (1 + overallEnlargementFactor)
        let newHeight = originalHeight * (1 + overallEnlargementFactor + topEnlargementFactor)

        // Adjust X and Y coordinates to center the enlargement
        let newX = originalX - ((newWidth - originalWidth) / 2)
        let newY = originalY - (originalHeight * topEnlargementFactor / 2) - ((newHeight - originalHeight) / 2)

        // Ensure the cropping rectangle stays within the bounds of the original image
        let cropRect = CGRect(
            x: max(0, newX),
            y: max(0, newY),
            width: min(image.size.width - newX, newWidth),
            height: min(image.size.height - newY, newHeight)
        )

        // Crop the image
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            print("Failed to crop image.")
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
```

This extension resizes the image to a specific size as well as fixing the orientation to make sure it is always upright and converting the image to a CVPixelBuffer to work with our model.
```swift
extension UIImage {
    // Resize the image to the target size
    func resized(to size: CGSize) -> UIImage? {
        // New image context with specific size
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        // Draw the image into the new context scaling it to fit
        self.draw(in: CGRect(origin: .zero, size: size))
        // Define the resized imaged and close
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    /// Adjust image orientation
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        // Reorients the image to be vertical
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
    
    /// Converts UIImage to CVPixelBuffer so it works with Core ML models
    func toCVPixelBuffer() -> CVPixelBuffer? {
        // Define width and height of the image in pixels
        let width = Int(size.width)
        let height = Int(size.height)
        
        // Specify compatibility attributes for the pixel buffer
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        // This will hold the image data
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32ARGB, attrs,
                                         &pixelBuffer)
        // Ensure successful creation of the pixel buffer
        guard status == kCVReturnSuccess, let unwrappedBuffer = pixelBuffer else {
            return nil
        }

        // Lock it for writing
        CVPixelBufferLockBaseAddress(unwrappedBuffer, .readOnly)
        // Get a pointer to the pixel buffer's base address
        let data = CVPixelBufferGetBaseAddress(unwrappedBuffer)

        // Set up a Core Graphics context using the pixel buffer's memory
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // Get the CGImage representation of the current UIImage
        guard let cgImage = self.cgImage else {
            return nil
        }
        // Draw the CGImage into the Core Graphics context
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        // Unlock the pixel buffer memory
        CVPixelBufferUnlockBaseAddress(unwrappedBuffer, .readOnly)

        return unwrappedBuffer
    }
}
```

vi. **Congratulations!**  
If you stuck-it-out to the end of the tutorial I'm glad! Feel free to mess around with my application and send me improvements, I'd love to see them!














