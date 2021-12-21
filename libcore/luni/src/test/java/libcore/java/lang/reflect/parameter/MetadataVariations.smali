#
# Copyright (C) 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Originally generated using baksmali and edited. See README.txt in this directory.

.class public interface abstract Llibcore/java/lang/reflect/parameter/MetadataVariations;
.super Ljava/lang/Object;
.source "MetadataVariations.java"


# virtual methods
.method public abstract badAccessModifier(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0xFF
        }
        names = {
            "p0"
        }
    .end annotation
.end method

.method public abstract badlyFormedAnnotation(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0xFF
        }
    .end annotation
.end method

.method public abstract emptyMethodParametersAnnotation()V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {}
        names = {}
    .end annotation
.end method

.method public abstract emptyName(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10
        }
        names = {
            ""
        }
    .end annotation
.end method

.method public abstract manyParameters(IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10,
            0x10
        }
        names = {
            "a000",
            "a001",
            "a002",
            "a003",
            "a004",
            "a005",
            "a006",
            "a007",
            "a008",
            "a009",
            "a010",
            "a011",
            "a012",
            "a013",
            "a014",
            "a015",
            "a016",
            "a017",
            "a018",
            "a019",
            "a020",
            "a021",
            "a022",
            "a023",
            "a024",
            "a025",
            "a026",
            "a027",
            "a028",
            "a029",
            "a030",
            "a031",
            "a032",
            "a033",
            "a034",
            "a035",
            "a036",
            "a037",
            "a038",
            "a039",
            "a040",
            "a041",
            "a042",
            "a043",
            "a044",
            "a045",
            "a046",
            "a047",
            "a048",
            "a049",
            "a050",
            "a051",
            "a052",
            "a053",
            "a054",
            "a055",
            "a056",
            "a057",
            "a058",
            "a059",
            "a060",
            "a061",
            "a062",
            "a063",
            "a064",
            "a065",
            "a066",
            "a067",
            "a068",
            "a069",
            "a070",
            "a071",
            "a072",
            "a073",
            "a074",
            "a075",
            "a076",
            "a077",
            "a078",
            "a079",
            "a080",
            "a081",
            "a082",
            "a083",
            "a084",
            "a085",
            "a086",
            "a087",
            "a088",
            "a089",
            "a090",
            "a091",
            "a092",
            "a093",
            "a094",
            "a095",
            "a096",
            "a097",
            "a098",
            "a099",
            "a100",
            "a101",
            "a102",
            "a103",
            "a104",
            "a105",
            "a106",
            "a107",
            "a108",
            "a109",
            "a110",
            "a111",
            "a112",
            "a113",
            "a114",
            "a115",
            "a116",
            "a117",
            "a118",
            "a119",
            "a120",
            "a121",
            "a122",
            "a123",
            "a124",
            "a125",
            "a126",
            "a127",
            "a128",
            "a129",
            "a130",
            "a131",
            "a132",
            "a133",
            "a134",
            "a135",
            "a136",
            "a137",
            "a138",
            "a139",
            "a140",
            "a141",
            "a142",
            "a143",
            "a144",
            "a145",
            "a146",
            "a147",
            "a148",
            "a149",
            "a150",
            "a151",
            "a152",
            "a153",
            "a154",
            "a155",
            "a156",
            "a157",
            "a158",
            "a159",
            "a160",
            "a161",
            "a162",
            "a163",
            "a164",
            "a165",
            "a166",
            "a167",
            "a168",
            "a169",
            "a170",
            "a171",
            "a172",
            "a173",
            "a174",
            "a175",
            "a176",
            "a177",
            "a178",
            "a179",
            "a180",
            "a181",
            "a182",
            "a183",
            "a184",
            "a185",
            "a186",
            "a187",
            "a188",
            "a189",
            "a190",
            "a191",
            "a192",
            "a193",
            "a194",
            "a195",
            "a196",
            "a197",
            "a198",
            "a199",
            "a200",
            "a201",
            "a202",
            "a203",
            "a204",
            "a205",
            "a206",
            "a207",
            "a208",
            "a209",
            "a210",
            "a211",
            "a212",
            "a213",
            "a214",
            "a215",
            "a216",
            "a217",
            "a218",
            "a219",
            "a220",
            "a221",
            "a222",
            "a223",
            "a224",
            "a225",
            "a226",
            "a227",
            "a228",
            "a229",
            "a230",
            "a231",
            "a232",
            "a233",
            "a234",
            "a235",
            "a236",
            "a237",
            "a238",
            "a239",
            "a240",
            "a241",
            "a242",
            "a243",
            "a244",
            "a245",
            "a246",
            "a247",
            "a248",
            "a249",
            "a250",
            "a251",
            "a252",
            "a253",
            "a254",
            "a255",
            "a256",
            "a257",
            "a258",
            "a259",
            "a260",
            "a261",
            "a262",
            "a263",
            "a264",
            "a265",
            "a266",
            "a267",
            "a268",
            "a269",
            "a270",
            "a271",
            "a272",
            "a273",
            "a274",
            "a275",
            "a276",
            "a277",
            "a278",
            "a279",
            "a280",
            "a281",
            "a282",
            "a283",
            "a284",
            "a285",
            "a286",
            "a287",
            "a288",
            "a289",
            "a290",
            "a291",
            "a292",
            "a293",
            "a294",
            "a295",
            "a296",
            "a297",
            "a298",
            "a299"
        }
    .end annotation
.end method

.method public abstract nameWithOpenSquareBracket(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = { 0x1 }
        names = { "a[a" }
    .end annotation
.end method

.method public abstract nameWithPeriod(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = { 0x1 }
        names = { "a.a" }
    .end annotation
.end method

.method public abstract nameWithSemicolon(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = { 0x1 }
        names = { "a;a" }
    .end annotation
.end method

.method public abstract nameWithSlash(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = { 0x1 }
        names = { "a/a" }
    .end annotation
.end method

.method public abstract nullName(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10
        }
        names = {
            null
        }
    .end annotation
.end method

.method public abstract tooFewAccessFlags(Ljava/lang/String;Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10
        }
        names = {
            "p0",
            "p1"
        }
    .end annotation
.end method

.method public abstract tooFewBoth(Ljava/lang/String;Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10
        }
        names = {
            "p0"
        }
    .end annotation
.end method

.method public abstract tooFewNames(Ljava/lang/String;Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10,
            0x10
        }
        names = {
            "p0"
        }
    .end annotation
.end method

.method public abstract tooManyAccessFlags(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10,
            0x10
        }
        names = {
            "p0"
        }
    .end annotation
.end method

.method public abstract tooManyBoth(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10,
            0x10
        }
        names = {
            "p0",
            "p1"
        }
    .end annotation
.end method

.method public abstract tooManyNames(Ljava/lang/String;)V
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x10
        }
        names = {
            "p0",
            "p1"
        }
    .end annotation
.end method
