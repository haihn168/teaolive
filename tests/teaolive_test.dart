#library('teaolive_test');

#import('helper/test_util.dart');

#import('../teaolive.dart');
// #import('../reporter/teaolive_html_reporter.dart');
#import('../reporter/teaolive_junit_xml_reporter.dart');

// DO NOT USE print FUNCTION!!
// We can't change the standard output stream in the current version of Dart.

void main(){
    
  addTest(testCase);

  // setTeaoliveReporter(new TeaoliveHtmlReporter());
  setTeaoliveReporter(new TeaoliveJUnitXMLReporter());
  teaoliveRun();
}

void testCase(){
  describe("save environment", (){
    it("save and restore", (){
      TeaoliveEnvironment env = getCurrentTeaoliveEnvironment();
      resetTeoliveEnvironment();
      
      // under new environment
      Sniffer sniffer = new Sniffer();
      setTeaoliveReporter(sniffer);

      addTest((){
        describe("success describe", (){
          it("success it", (){
          });
        });
        describe("failure describe", (){
          it("failure it", (){
            expect(1).toBe(2);
          });
        });
        describe("ignore describe, (this describe be success)", (){
          xit("ignore it", (){
          });
          xdescribe("ignore describe", (){
          });
        });
      });
      
      teaoliveRun();
      
      // continue root testing...
      restoreTeaoliveEnvironment(env);
      
      // check result
      expect(sniffer.describe.success).toBe(2);
      expect(sniffer.describe.failure).toBe(1);
      expect(sniffer.describe.ignore).toBe(1);

      expect(sniffer.it.success).toBe(1);
      expect(sniffer.it.failure).toBe(1);
      expect(sniffer.it.ignore).toBe(1);
    });
  });

  describe("matchers", (){
    it("toBe matcher compare by ===", (){
      expect(1).toBe(1);
      expect(1).not.toBe(2);
      expect(1).not.toBe(null);
      
      expect("hoge").toBe("hoge"); // same object
      {
        StringBuffer buffer = new StringBuffer();
        buffer.add("ho");
        buffer.add("ge");
        expect("hoge").not.toBe(buffer.toString()); // not same object
      }
    });
    
    it("toEqual matcher compare by ==", (){
      expect(1).toEqual(1);
      expect(1).not.toEqual(2);
      expect(1).not.toEqual(null);
      
      expect("hoge").toEqual("hoge");
      {
        StringBuffer buffer = new StringBuffer();
        buffer.add("ho");
        buffer.add("ge");
        expect("hoge").toEqual(buffer.toString());
      }
    });
    
    it("toBeNull matcher is check null",(){
      expect(1).not.toBeNull();
      expect(null).toBeNull();
      expect("hoge").not.toBeNull();
    });
  });

  describe("operator functions", (){
    it("beforeEach and afterEach", (){
      TeaoliveEnvironment env = getCurrentTeaoliveEnvironment();
      resetTeoliveEnvironment();
      
      // under new environment
      Sniffer sniffer = new Sniffer();
      setTeaoliveReporter(sniffer);

      StringBuffer builder = new StringBuffer();
      
      addTest((){
        describe("beforeEach", (){
          beforeEach((){
            builder.add("b1 ");
          });
          it("...", (){
            builder.add("m1 ");
          });
        });
        describe("afterEach", (){
          afterEach((){
            builder.add("a2 ");
          });
          it("...", (){
            builder.add("m2 ");
          });
        });
        describe("beforeEach twice", (){
          beforeEach((){
            builder.add("b3-1 ");
          });
          beforeEach((){
            builder.add("b3-2 ");
          });
          it("...", (){
            builder.add("m3 ");
          });
        });
        describe("beforeEach twice", (){
          afterEach((){
            builder.add("a4-1 ");
          });
          afterEach((){
            builder.add("a4-2 ");
          });
          it("...", (){
            builder.add("m4 ");
          });
        });
        describe("multi spec", (){
          beforeEach((){
            builder.add("b5 ");
          });
          afterEach((){
            builder.add("a5 ");
          });
          it("...", (){
            builder.add("m5-1 ");
          });
          it("...", (){
            builder.add("m5-2 ");
          });
        });
        describe("nested(outer)", (){
          beforeEach((){
            builder.add("b6-o ");
          });
          afterEach((){
            builder.add("a6-o ");
          });
          it("...", (){
            builder.add("m6-o ");
          });
          describe("nested(inner)", (){
            beforeEach((){
              builder.add("b6-i ");
            });
            afterEach((){
              builder.add("a6-i ");
            });
            it("...", (){
              builder.add("m6-i ");
            });
          });          
        });
      });
      
      teaoliveRun();
      
      // continue root testing...
      restoreTeaoliveEnvironment(env);
      
      // check result
      expect(builder.toString()).toEqual("b1 m1 m2 a2 b3-1 b3-2 m3 m4 a4-1 a4-2 b5 m5-1 a5 b5 m5-2 a5 b6-o m6-o a6-o b6-o b6-i m6-i a6-i a6-o ");
    });
  });
}
